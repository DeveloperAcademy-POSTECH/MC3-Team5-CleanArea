//
//  CameraButtonView.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/16.
//

import SwiftUI

struct CameraButton: View {
    @StateObject var mainViewModel: MainViewModel
    @State private var image = UIImage()
    @State var changeCamera: Bool = false
    @State private var showModal = false
    @State var didCapture: Bool = false
    @State var didPhoto: Bool = false
    @State var isFlash: Bool = false
    @State var name: String = "bolt.fill"
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button(action: {
            UIView.setAnimationsEnabled(false)
            showModal = true
        }) {
            ZStack {
                Circle()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: UIScreen.getHeight(64))
                    .foregroundColor(Color("B1"))
                
                Image(systemName: "camera.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: UIScreen.getHeight(24))
                    .foregroundColor(.white)
            }
        }.fullScreenCover(isPresented: $showModal) {
            NavigationView {
                VStack {
                    HStack {
                        Button(action: {
                            showModal = false
                        }) {
                            Image(systemName: "chevron.backward")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.getWidth(16), height: UIScreen.getHeight(22))
                                .foregroundColor(Color("G4"))
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
                               isFlash: $isFlash)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth*4/3)
                    
                    Spacer()
                        .frame(height: UIScreen.getHeight(40))
                    
                    ZStack {
                        Buttons(mainViewModel: mainViewModel,
                                isFlash: $isFlash,
                                didCapture: $didCapture,
                                changeCamera: $changeCamera,
                                image: $image,
                                showModal: $showModal,
                                didPhoto: $didPhoto)
                    }
                }
                
            }
        }
        .onAppear{
            UIView.setAnimationsEnabled(true)
        }
    }
}
