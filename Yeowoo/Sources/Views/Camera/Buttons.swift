//
//  B.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/17.
//

import SwiftUI

struct Buttons: View {
    @StateObject var mainViewModel: MainViewModel
    @Binding var isFlash: Bool
    @Binding var didCapture: Bool
    @Binding var changeCamera: Bool
    @Binding var image: UIImage
    @Binding var showModal: Bool
    @Binding var didPhoto: Bool
    
    @State var open = false
    var body: some View {
        HStack(spacing: UIScreen.getWidth(40)) {
            Button(action: {
                isFlash.toggle()
            }) {
                FeatureButton(imageName: isFlash == true ? "bolt.fill" : "bolt.slash.fill")
            }
            
            NavigationLink(destination: EditView(mainViewModel: mainViewModel,
                                                 showModal: $showModal,
                                                 image: $image,
                                                 didPhoto: $didPhoto),
                           isActive: $open) {
                Button(action: {
                    didCapture = true
                    open = true
                }) {
                    Image("CameraButton")
                }
            }
            
            Button(action: {
                changeCamera.toggle()
            }) {
                FeatureButton(imageName: "arrow.triangle.2.circlepath")
            }
        }
    }
}
