//
//  CameraView.swift
//  Card
//
//  Created by Seungsub Oh on 4/12/24.
//

import SwiftUI

struct CameraView: View {
    @Binding var photo: UIImage?
    @Binding var isPresented: Bool
    
    @State var viewModel: CameraViewModel = .init()
    
    var body: some View {
        Group {
            if let frame = viewModel.cameraFrame {
                Image(decorative: frame, scale: 1, orientation: viewModel.orientation.imageOrientation)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay(alignment: viewModel.orientation.buttonAlignment) {
                        Button {
                            photo = UIImage(cgImage: frame, scale: 1, orientation: viewModel.orientation.uiimageOrientation)
                            isPresented.toggle()
                        } label: {
                            Circle()
                                .stroke(lineWidth: 5)
                                .frame(width: 80, height: 80)
                        }
                        .foregroundStyle(Color(uiColor: .label))
                        .shadow(radius: 10)
                        .padding()
                    }
            } else {
                Image(systemName: "square.stack.3d.down.right")
                    .symbolEffect(
                        .variableColor
                            .iterative
                            .dimInactiveLayers
                            .nonReversing
                    )
                    .font(.largeTitle)
            }
        }
        .overlay(alignment: .topLeading) {
            Button {
                isPresented.toggle()
            } label: {
                Image(systemName: "xmark")
                    .font(.largeTitle)
            }
            .foregroundStyle(Color(uiColor: .label))
            .shadow(radius: 10)
            .padding()
        }
        .onDisappear(perform: viewModel.stopSession)
    }
}

#Preview {
    CameraView(photo: .constant(nil), isPresented: .constant(true))
}
