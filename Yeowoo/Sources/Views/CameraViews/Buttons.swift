//
//  B.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/17.
//

import SwiftUI

struct Buttons: View {
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
            
            NavigationLink(destination: EditView(showModal: $showModal, image: $image, didPhoto: $didPhoto),
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

//struct Buttons_Previews: PreviewProvider {
//    static var previews: some View {
//        Buttons(isFlash: .constant(false), didCapture: .constant(false), changeCamera: .constant(false))
//    }
//}
