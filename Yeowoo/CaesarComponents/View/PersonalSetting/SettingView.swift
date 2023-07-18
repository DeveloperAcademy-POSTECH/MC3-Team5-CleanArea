//
//  SettingView.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/14.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = "노루궁뎅이"
    @State private var role = "norubutt"
    private var myImage = "Noru"
    //사진 촬영 알림 토글
    @State private var notiToggle = true
    //회원탈퇴 alert
    @State private var deletingAccount = false
    //로그아웃  action sheet
    @State private var loggingOutSheet = false
    
    
    var body: some View {
            //VStack 뷰
            VStack{
                //프로필 뷰
                VStack{
                    Text("프로필")
                        .modifier(SubTitleFont())

                    NavigationLink{
//                        ProfileSettingView(selectedImage: $myImage)
                        ProfileSettingView(myImage: myImage)
                            .navigationBarBackButtonHidden()
                    }label: {
                        HStack{
                            
                            Image(myImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 64, height: 64)
                                .background(Color.mainColor)
                                .clipShape(Circle())
                                .padding(.horizontal, 10 )
                            HStack{
                                VStack(alignment: .leading){
                                    Text(name)
                                        .font(.headline)
                                    Text(role)
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                    
                                }
                                
                                Spacer()
                                
                                    Image(systemName: "chevron.right")
                                        .imageScale(.large)
                                        .foregroundColor(.gray)
                                        .opacity(0.2)
                                        .padding(.trailing, 20)
                            }
                            
                        }
                        .modifier(CardViewModifier(height: 95))
                    }
                }
                
                //알림 on/off
                VStack{
                    Text("설정")
                        .modifier(SubTitleFont())
                    
                    HStack{
                        ZStack{
                            Image(systemName: "bell.fill")
                                .resizable()
                                .imageScale(.small)
                                .foregroundColor(.gray)
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.gray)
                                .opacity(0.1)
                        }
                            .padding(.horizontal, 10 )
                        HStack{
                            Text("사진 촬영 알림 받기")
                                .font(.system(size: 16, weight: .regular, design: .default))
                       
                            Spacer()
                            
                            Toggle("", isOn: $notiToggle)
                                .toggleStyle(SwitchToggleStyle(tint: Color.mainColor))
                                .padding(.trailing, 20)
                    }
                    }
                    .modifier(CardViewModifier())
                }
                
                Spacer()
                
                //회원탈퇴/로그아웃
                VStack{
                    //회원탈퇴
                            Button{
                                deletingAccount = true
                            } label: {
                                    Text("회원 탈퇴")
                                        .font(.system(size: 18, weight: .bold, design: .default))
                                        .foregroundColor(Color.warningRed)
                        }
                        .frame(width: UIScreen.main.bounds.width - 30, height: 54)
                        .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color.whiteGray))
                    //탈퇴 alert
                        .alert(isPresented: $deletingAccount) {
                            Alert(
                                title: Text("회원 탈퇴"),
                                message: Text("탈퇴시 사진 복구가 불가능합니다. 정말 탈퇴하시겠습니까?"),
                                primaryButton: .destructive(Text("탈퇴")
                                    .foregroundColor(.warningRed),
                                                        action: {
                                                  //탈퇴코드
                                                }),
                                                secondaryButton: .cancel(Text("취소"))
                            )
                        }

                    
                    //로그아웃
                        Button{
                            loggingOutSheet = true
                        } label: {
                                Text("로그아웃")
                                    .font(.system(size: 18, weight: .bold, design: .default))
                                    .foregroundColor(Color(red: 100 / 255, green: 100 / 255, blue: 100 / 255))
                    }
                        .frame(width: UIScreen.main.bounds.width - 30, height: 54)
                        .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color.whiteGray))
                    //로그아웃 시트
                        .actionSheet(isPresented: $loggingOutSheet) {
                            ActionSheet(title: Text("로그아웃"),
                            message: Text("정말로 로그아웃하시겠습니까?"),
                                        buttons: [
                                            .destructive(Text("로그아웃")) { print("User logged out.") },
                                      .cancel(Text("취소"))
                                        ])
                        }

                    
                }

                
                
            }
            .navigationTitle("설정")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.white)
            .modifier(BackToolBarModifier())
            .accentColor(.black)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
