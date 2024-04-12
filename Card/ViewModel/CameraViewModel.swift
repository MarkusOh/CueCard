//
//  CameraViewModel.swift
//  Card
//
//  Created by Seungsub Oh on 4/12/24.
//

import Observation
import UIKit
import AVFoundation
import SwiftUI

@Observable
class CameraViewModel: NSObject, Identifiable, AVCaptureVideoDataOutputSampleBufferDelegate {
    var id: UUID
    private let session: AVCaptureSession
    private let output: AVCaptureVideoDataOutput
    private let queue: DispatchQueue
    private let context: CIContext
    private var observer: NSObjectProtocol?
    
    var cameraFrame: CGImage?
    var orientation: UIDeviceOrientation
    
    override init() {
        let id = UUID()
        self.id = id
        self.session = .init()
        self.output = .init()
        self.queue = .init(label: "camera.service.\(id.uuidString)", qos: .userInitiated)
        self.context = .init(options: nil)
        self.orientation = UIDevice.current.orientation
        self.observer = nil
        super.init()
        
        self.observer = NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: nil) { [weak self] note in
            guard let device = note.object as? UIDevice else {
                return
            }
            
            self?.orientation = device.orientation
        }
        
        addCameraInput()
        addVideoOutput()
        startSession()
    }
    
    func addCameraInput() {
        guard let device = AVCaptureDevice.default(for: .video),
              let cameraInput = try? AVCaptureDeviceInput(device: device) else {
            return
        }
        
        session.addInput(cameraInput)
    }
    
    func addVideoOutput() {
        let bufferKey = kCVPixelBufferPixelFormatTypeKey as NSString
        let formatType = NSNumber(value: kCVPixelFormatType_32BGRA)
        
        output.videoSettings = [bufferKey: formatType] as [String: Any]
        output.setSampleBufferDelegate(self, queue: queue)
        session.addOutput(output)
    }
    
    func startSession() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.session.startRunning()
        }
    }
    
    func stopSession() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.session.stopRunning()
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        DispatchQueue.main.async { [weak self] in
            guard let buffer = CMSampleBufferGetImageBuffer(sampleBuffer),
                  let ciImage = Optional(CIImage(cvPixelBuffer: buffer)),
                  let cgImage = self?.context.createCGImage(ciImage, from: ciImage.extent) else {
                return
            }
            
            self?.cameraFrame = cgImage
        }
    }
    
    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}

extension UIDeviceOrientation {
    var imageOrientation: Image.Orientation {
        switch self {
        case .landscapeLeft:
            return .up
        case .landscapeRight:
            return .down
        case .portrait:
            return .right
        case .portraitUpsideDown:
            return .left
        default:
            return .right
        }
    }
    
    var uiimageOrientation: UIImage.Orientation {
        switch self {
        case .landscapeLeft:
            return .up
        case .landscapeRight:
            return .down
        case .portrait:
            return .right
        case .portraitUpsideDown:
            return .left
        default:
            return .right
        }
    }
    
    var buttonAlignment: Alignment {
        switch self {
        case .landscapeLeft:
            return .trailing
        case .landscapeRight:
            return .leading
        case .portrait:
            return .bottom
        default:
            return .bottom
        }
    }
}
