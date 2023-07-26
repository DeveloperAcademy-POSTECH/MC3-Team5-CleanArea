//
//  ProfileSettingView.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/16.
//

import SwiftUI
import PhotosUI

struct ProfileSettingView: View {
    @Environment(\.dismiss) var dismiss
    var myImage: String
    @State private var selectedImage: PhotosPickerItem?
    @State private var nickName = ""
    @State private var identity = ""
    @State private var sameID:Bool? = nil
    
    var body: some View {
        VStack{
            
            //selecting profile picture (사진 수정 버튼)
            PhotosPicker(selection:  $selectedImage) {
                ZStack{
                    //내사진
                    Image(myImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 130, height: 130)
                        .background(Color.mainColor)
                        .clipShape(Circle())
                        .padding(.horizontal, 10 )
                    //카메라 모양
                    Circle()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color(red: 243 / 255, green: 243 / 255, blue: 243 / 255))
                        .overlay{
                            Image(systemName: "camera.fill")
                                .foregroundColor(Color(red: 100 / 255, green: 100 / 255, blue: 100 / 255))
                        }
                        .offset(x: 45, y: 45)
                }
            }
            //닉네임 변경란
            EditProfileRowView(Profile: "닉네임", placeholder: "닉네임을 써주세요", text: $nickName)
            
            //아이디 변경란
            ZStack(alignment: .trailing) {
                EditProfileRowView(Profile: "아이디", placeholder: "아이디를 써주세요", text: $identity)
                Button{
                    //(need 파베 logic)
                    if !identity.isEmpty {
                        sameID = true
                    } else {
                        sameID = false
                    }
                    print(identity)
                }label:
                    { Text("중복확인")
                        .font(.system(size: 14, weight: .semibold, design: .default))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.mainColor)
                        .cornerRadius(10)
                }
                .padding(.trailing, 10)
            }
            
            if let isSameID = sameID {
                isSameID ?
                Text("사용하실 수 있는 아이디입니다.")
                    .font(.footnote)
                    .foregroundColor(Color.mainColor) :
                Text("사용하실 수 없는 아이디입니다.")
                    .font(.footnote)
                    .foregroundColor(Color.warningRed)
            }
            
            Spacer()
            
            Button{
                dismiss()
            } label: {
                    Text("저장하기")
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .foregroundColor(Color.white)
        }
        .frame(width: UIScreen.main.bounds.width - 30, height: 54)
        .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(Color.mainColor))

            

        }
        .navigationTitle("프로필 수정하기")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.white)
        .modifier(BackToolBarModifier())
    }
}

struct ProfileSettingView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingView(myImage: "Noru")
    }
}



