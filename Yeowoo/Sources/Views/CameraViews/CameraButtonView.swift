//
//  CameraButtonView.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/16.
//

import SwiftUI

struct CameraButtonView: View {
    @State private var image = UIImage()
    @State private var showModal = false
    @State var didCapture: Bool = false
    @State var didPhoto: Bool = false
    @State var changeCamera: Bool = false
    @State var isFlash: Bool = false
    @State var name: String = "bolt.fill"
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button(action: {
            showModal = true
        }) {
            Image(systemName: "camera.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.getWidth(76))
                .foregroundColor(Color("ButtonColor"))
        }.fullScreenCover(isPresented: $showModal) {
            if !didPhoto {
                VStack {
                    HStack {
                        Button(action: {
                            showModal = false
                        }) {
                            Image(systemName: "chevron.backward")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.getWidth(16), height: UIScreen.getHeight(22))
                                .foregroundColor(.gray)
                                .padding(.leading, UIScreen.getWidth(20))
                        }
                        .frame(width: UIScreen.getHeight(44), height: UIScreen.getHeight(44))
                        
                        Spacer()
                    }
                    
                    Spacer()
                        .frame(height: UIScreen.getHeight(29))
                    
                    CameraView(didcap: $didCapture,
                               selectedImage: $image,
                               didPhoto: $didPhoto,
                               changeCamera: $changeCamera,
                               isFlash: $isFlash,
                               name: $name
                    )
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth*4/3)
                    
                    Spacer()
                        .frame(height: UIScreen.getHeight(40))
                    ZStack {
                        Buttons(isFlash: $isFlash,
                                didCapture: $didCapture,
                                changeCamera: $changeCamera)
                    }
                }
            } else {
                EditView(showModal: $showModal, image: $image, didPhoto: $didPhoto)
            }
        }
    }
}

struct CameraButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CameraButtonView()
    }
}
