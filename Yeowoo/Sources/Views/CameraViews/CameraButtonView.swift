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
                               isFlash: $isFlash
                    )
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth*4/3)
                    
                    Spacer()
                        .frame(height: UIScreen.getHeight(40))
                    
                    HStack(spacing: UIScreen.getWidth(40)) {
                        Button(action: {
                            isFlash.toggle()
                        }) {
                            isFlash == true ? Buttons(imageName: "bolt.fill") : Buttons(imageName: "bolt.slash.fill")
                        }
                        
                        Button(action: {
                            didCapture = true
                        }) {
                            Image("CameraButton")
                        }
                        
                        Button(action: {
                            changeCamera.toggle()
                        }) {
                            Buttons(imageName: "arrow.triangle.2.circlepath")
                        }
                    }
                }
            }
        }
    }
}

struct CameraButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CameraButtonView()
    }
}
