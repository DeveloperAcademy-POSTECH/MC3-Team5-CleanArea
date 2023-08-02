//
//  EditView.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/16.
//

import SwiftUI

import SwiftUI

struct EditView: View {
    @StateObject var mainViewModel: MainViewModel
    @Binding var showModal: Bool
    @Binding var image: UIImage
    @Binding var didPhoto: Bool
    @State var contentsText = ""
    @State var isWrite = false
    @State var showingAlert = false
    @State var isRole = false
    @State var myAlbum = true
    @State var allAlbum = false
    let baseText = "사진에 대한 설명을 작성해주세요. (선택)"
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    showingAlert = true
                }) {
                    Image(systemName: "chevron.backward")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.getWidth(16), height: UIScreen.getHeight(22))
                        .foregroundColor(Color("G4"))
                        .padding(.leading, UIScreen.getWidth(20))
                }
                .frame(width: UIScreen.getHeight(44), height: UIScreen.getHeight(44))
                .alert("사진 삭제", isPresented: $showingAlert) {
                    Button("취소", role: .cancel) {
                        showingAlert = false
                    }
                    Button("삭제", role: .destructive) {
                        didPhoto = false
                        image = UIImage()
                        dismiss()
                    }
                } message: {
                    Text("사진을 정말 삭제하시겠어요?")
                }
                
                Spacer()
            }
            Spacer()
                .frame(height: UIScreen.getHeight(29))
            
            ZStack{
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

            }.frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth*4/3)
            
            Spacer()
                .frame(height: UIScreen.getHeight(12))
            
            Spacer()
            
            Button(action: {
                isWrite.toggle()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 100)
                        .foregroundColor(Color("B1"))
                        .frame(height: UIScreen.getHeight(54))
                        .padding([.leading, .trailing], UIScreen.getWidth(20))
                    
                    Text("다음 \(Image(systemName: "chevron.right"))")
                        .font(.custom18semibold())
                        .foregroundColor(.white)
                }
            }.sheet(isPresented: $isWrite) {
                WriteTextView(mainViewModel: mainViewModel, showModal: $showModal, contentsText: $contentsText, image: $image, didPhoto: $didPhoto)
                    .presentationDetents([.height(UIScreen.getHeight(338)), .large])
            }
            
            Spacer()
                .frame(height: UIScreen.getHeight(56))
        }.navigationBarHidden(true)
    }
}
