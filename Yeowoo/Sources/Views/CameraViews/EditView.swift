//
//  EditView.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/16.
//

import SwiftUI

import SwiftUI

struct EditView: View {
    @Binding var showModal: Bool
    @Binding var image: UIImage
    @Binding var didPhoto: Bool
    @State var contentsText = "100자 이내로 작성해주세요"
    @State var isWrite = false
    @State var showingAlert = false
    @State var isRole = false
    @State var myAlbum = true
    @State var allAlbum = false
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
                        .foregroundColor(.gray)
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
                
                VStack {
                    Spacer()
                        
                    Text(contentsText)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color(uiColor: .systemGray6))
                            .opacity(0.5))
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .leading)
                        .padding([.leading, .bottom], UIScreen.getWidth(20))
                }
            }.frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth*4/3)
            
            Spacer()
                .frame(height: UIScreen.getHeight(12))
            
            HStack {
                Button(action: {
                    isWrite = true
                }) {
                    Image("WriteButton")
                }.sheet(isPresented: $isWrite) {
                    WriteTextView(isWirte: $isWrite, contentsText: $contentsText)
                        .presentationDetents([.height(UIScreen.getHeight(338)), .large])
                }
                
                Button(action: {
                    isRole = true
                }) {
                    Image("FolderButton")
                }.sheet(isPresented: $isRole) {
                    RoleView(myAlbum: $myAlbum, allAlbum: $allAlbum)
                        .presentationDetents([.height(UIScreen.getHeight(283)), .large])
                }
            }
            
            Spacer()
            
            Button(action: {
                didPhoto = false
                showModal = false
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("ButtonColor"))
                        .frame(height: UIScreen.getHeight(54))
                        .padding([.leading, .trailing], UIScreen.getWidth(20))
                    
                    Text("업로드하기")
                        .font(.custom18semibold())
                        .foregroundColor(.white)
                }
            }
        }.navigationBarHidden(true)
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(showModal: .constant(false), image: .constant(UIImage(systemName: "square")!), didPhoto: .constant(false))
    }
}
