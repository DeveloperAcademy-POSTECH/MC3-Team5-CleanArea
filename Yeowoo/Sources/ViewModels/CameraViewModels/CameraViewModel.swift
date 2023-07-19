//
//  CameraViewModel.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/16.
//

import Foundation
import UIKit
import SwiftUI
import AVKit

struct CameraView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    @Binding var didcap: Bool
    @Binding var selectedImage: UIImage
    @Binding var didPhoto: Bool
    @Binding var changeCamera: Bool
    @Binding var isFlash: Bool
    @Binding var name: String
    @Environment(\.dismiss) private var dismiss

    let viewController = UIViewControllerType()
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        viewController.delegate = context.coordinator
        viewController.sourceType = .camera
        viewController.cameraCaptureMode = .photo
        viewController.showsCameraControls = false

        return viewController
            
    }
    
    func updateUIViewController (_ uiViewController: UIViewControllerType, context: Context) {
        viewController.cameraDevice = changeCamera == true ? .front : .rear
        
        viewController.cameraFlashMode = isFlash == true ? .on : .off

        viewController.cameraFlashMode = isFlash == true ? .on : .off
        
        if viewController.cameraCaptureMode != .photo {
            viewController.mediaTypes = ["public.image"]
            viewController.cameraCaptureMode = .photo
        }

        didcap == true ? viewController.takePicture() : (didcap = false)
    }
    
    func makeCoordinator() -> CameraView.Coordinator {
        return Coordinator(self)
    }
}

extension CameraView {
    
    class Coordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: CameraView
        @Environment(\.dismiss) private var dismiss
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
                parent.didPhoto = true
                parent.didcap = false
            }
        }
    }
}
