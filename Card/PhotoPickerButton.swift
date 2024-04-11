//
//  PhotoPickerButton.swift
//  Card
//
//  Created by Seungsub Oh on 4/11/24.
//

import SwiftUI
import PhotosUI
import Photos

struct ErrorMessage: Identifiable {
    var id: UUID = .init()
    
    let title: LocalizedStringKey
    let description: LocalizedStringKey
}

struct PhotoPickerButton: View {
    @Binding var image: Data?
    
    // Photo Library Result
    @State private var showPhotoPickerRequest = false
    @State private var showPhotoPicker = false
    @State private var photoPickerItem: PhotosPickerItem? = nil
    @State private var photoPickerData: Data? = nil
    
    // Camera View Result
    @State private var showCameraViewRequest = false
    @State private var showCameraView = false
    @State private var shotPhoto: UIImage?
    @State private var errorMessage: ErrorMessage? = nil
    
    // File Choice Result
    @State private var showFileImporter = false
    @State private var importedFile: Data?
    
    var detectedImage: Data? {
        // Photo library result
        if let photoPickerData = photoPickerData {
            return photoPickerData
        
        // Camera view result
        } else if let shotPhoto = shotPhoto {
            let data = shotPhoto.pngData()
            return data
            
        // File selection result
        } else if let importedFile = importedFile {
            return importedFile
            
        // User has not made any decision yet
        } else {
            return nil
        }
    }
    
    var body: some View {
        Menu("Select a photo", systemImage: "photo") {
            Button("Choose File", systemImage: "folder") {
                showFileImporter = true
            }
            
            Button("Take Photo", systemImage: "camera") {
                showCameraViewRequest = true
            }
            
            Button("Photo Library", systemImage: "photo.on.rectangle") {
                showPhotoPickerRequest = true
            }
        }
        .labelStyle(.iconOnly)
        .fullScreenCover(isPresented: $showCameraView) {
            CameraView(photo: $shotPhoto, show: $showCameraView)
        }
        .alert(item: $errorMessage) { errorMessage in
            Alert(title: Text(errorMessage.title), message: Text(errorMessage.description))
        }
        .photosPicker(isPresented: $showPhotoPicker, selection: $photoPickerItem, matching: .images)
        .task(id: photoPickerItem) {
            guard let photoPickerItem = photoPickerItem else {
                return
            }
            
            photoPickerData = try? await photoPickerItem.loadTransferable(type: Data.self)
        }
        .fileImporter(isPresented: $showFileImporter, allowedContentTypes: [.image], allowsMultipleSelection: false) { result in
            switch result {
            case .success(let success):
                let dataList = success.compactMap { url -> Data? in
                    guard url.startAccessingSecurityScopedResource() else {
                        return nil
                    }
                    
                    let eachData = try? Data(contentsOf: url)
                    url.stopAccessingSecurityScopedResource()
                    
                    return eachData
                }
                
                guard dataList.isEmpty == false else {
                    errorMessage = .init(title: "File Importing Failed", description: "File importing failed as the data is not contained in the specified URL.")
                    return
                }
                
                importedFile = dataList.first
                
            case .failure(let failure):
                errorMessage = .init(title: "File Importing Failed", description: "File importing failed due to (\(failure.localizedDescription)) reason.")
            }
        }
        .task(id: showCameraViewRequest) {
            guard showCameraViewRequest else {
                return
            }
            
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            
            let inaccessibleError = ErrorMessage(
                title: "Camera Inaccessible",
                description: "Camera is inaccessible. Please grant the permission in settings page."
            )
            
            switch status {
            case .notDetermined:
                let isGranted = await AVCaptureDevice.requestAccess(for: .video)
                
                if isGranted {
                    showCameraView = true
                } else {
                    errorMessage = inaccessibleError
                }
                
            case .restricted, .denied:
                errorMessage = inaccessibleError
                
            case .authorized:
                showCameraView.toggle()
                
            @unknown default:
                fatalError("Unknown AVCaptureDevice status found")
            }
            
            showCameraViewRequest = false
        }
        .task(id: showPhotoPickerRequest) {
            guard showPhotoPickerRequest else {
                return
            }
            
            let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            
            let inaccessibleError = ErrorMessage(
                title: "Photos Library Inaccessible",
                description: "Photos library is inaccessible. Please grant the permission in settings page."
            )
            
            switch status {
            case .notDetermined:
                let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
                
                if status == .authorized {
                    showPhotoPicker = true
                } else {
                    errorMessage = inaccessibleError
                }
                
            case .restricted, .denied, .limited:
                errorMessage = inaccessibleError
            case .authorized:
                showPhotoPicker = true
            @unknown default:
                fatalError("Unknown photos library auth status found")
            }
            
            showPhotoPickerRequest = false
        }
        .onChange(of: detectedImage) { oldValue, newValue in
            guard let newValue = newValue,
                  let originalImage = UIImage(data: newValue) else {
                return
            }
            
            let resizedImage = resizeImage(originalImage)
            image = resizedImage.jpegData(compressionQuality: 0.8)
        }
    }
    
    func resizeImage(_ image: UIImage) -> UIImage {
        let maxHeight: CGFloat = 250
        let aspectRatio = image.size.width / image.size.height
        var newSize = CGSize(width: image.size.width, height: image.size.height)
        
        // Check if original height is less than 250, if yes, no need to resize
        if image.size.height < maxHeight {
            return image
        }
        
        newSize.height = maxHeight
        newSize.width = floor(maxHeight * aspectRatio)
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        
        let newImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
        
        return newImage
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Binding var photo: UIImage?
    @Binding var show: Bool
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(photo: $photo, show: $show)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var photo: Binding<UIImage?>
        var show: Binding<Bool>
        
        init(photo: Binding<UIImage?>, show: Binding<Bool>) {
            self.photo = photo
            self.show = show
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let selectedImage = info[.originalImage] as? UIImage else { return }
            photo.wrappedValue = selectedImage
            show.wrappedValue.toggle()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            show.wrappedValue.toggle()
        }
    }
}

#Preview {
    PhotoPickerButton(image: .constant(nil))
}
