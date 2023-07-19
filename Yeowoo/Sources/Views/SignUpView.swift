//
//  SignUpView.swift
//  Yeowoo
//
//  Created by Jisu Lee on 2023/07/17.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var ID = ""
    @State private var doubleCheck: Bool = false
        
    @State private var password = ""
    @State private var password1 = ""

    @State private var nickname = ""
    
    @State var isLoggedIn: Bool = false
    @State var isShownPassword: Bool = true
    @State var isShownPassword1: Bool = true
    
    
    var body: some View {
        VStack{
            //아이디
            VStack(alignment: .leading){
                //아이디
                Text("아이디")
                    .font(.title3)
                    .fontWeight(.medium)
                    .padding(.leading, 8)
                
                ZStack(alignment: .trailing){
                    //아이디 입력창
                    TextField("아이디를 입력하세요", text: $ID)
                        .padding()
                        .frame(width: 350, height: 46)
                        .background(Color("G5"))
                        .cornerRadius(10)
                    
                    //중복확인 버튼
                    Button(action: {
                        doubleCheck.toggle()
                    }) {
                        Text("중복확인")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 69, height: 24)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color("B1")))
                    }
                    .padding(10)
                }
                
                //** 아이디 확인 메시지
                Text("사용하실 수 있는 아이디입니다")
                    .opacity(!doubleCheck ? 0 : 1 )
                Text("사용하실 수 없는 아이디입니다")
                    .opacity(doubleCheck ? 0 : 1 )
                Spacer()
                    .frame(height: 30)
            }
            
            //비밀번호
            VStack(alignment: .leading){
                //비밀번호
                Text("비밀번호")
                    .font(.title3)
                    .fontWeight(.medium)
                    .padding(.leading, 8)
                
                //비밀번호 입력창
                ZStack(alignment: .trailing) {
                    if isShownPassword{
                        SecureField("비밀번호를 입력하세요", text: $password)
                            .padding()
                            .frame(width: 350, height: 46)
                            .background(Color("G5"))
                            .cornerRadius(10)
                    } else { TextField("비밀번호를 입력하세요", text: $password)
                            .padding()
                            .frame(width: 350, height: 46)
                            .background(Color("G5"))
                            .cornerRadius(10)
                    }
                    //입력시 비밀번호 보이기 및 감추기
                    Button {
                        isShownPassword.toggle()
                    } label: {
                        Image(systemName: isShownPassword ? "eye.slash.fill" : "eye")
                            .foregroundColor(Color("G3"))
                    }
                    .padding()
                }
                
                //비밀번호 재확인
                ZStack(alignment: .trailing) {
                    if isShownPassword1{
                        SecureField("비밀번호를 다시 입력해주세요", text: $password1)
                            .padding()
                            .frame(width: 350, height: 46)
                            .background(Color("G5"))
                            .cornerRadius(10)
                    } else { TextField("비밀번호를 다시 입력해주세요", text: $password1)
                            .padding()
                            .frame(width: 350, height: 46)
                            .background(Color("G5"))
                            .cornerRadius(10)
                    }
                    //입력시 비밀번호 보이기 및 감추기
                    Button {
                        isShownPassword1.toggle()
                    } label: {
                        Image(systemName: isShownPassword1 ? "eye.slash.fill" : "eye")
                            .foregroundColor(Color("G3"))
                    }
                    .padding()
                }
                
                //비밀번호 확인 메시지
                if password == "" && password1 == "" {
                    Text("비밀번호가 일치합니다")
                        .opacity(0)
                } else if password == password1 {
                    Text("비밀번호가 일치합니다")
                        .foregroundColor(Color("B1"))
                } else {
                    Text("비밀번호가 일치하지 않습니다")
                        .foregroundColor(Color("R1"))
                }
                
                Spacer()
                    .frame(height: 30)
            }
            
            //닉네임
            VStack(alignment: .leading){
                
                //닉네임
                Text("닉네임")
                    .font(.title3)
                    .fontWeight(.medium)
                    .padding(.leading, 8)
                
                //닉네임 입력창
                TextField("두 글자 이상으로 된 닉네임", text: $nickname)
                    .padding()
                    .frame(width: 350, height: 46)
                    .background(Color("G5"))
                    .cornerRadius(10)
                
                //닉네임 확인 메시지
                if !nickname.isEmpty {
                    if nickname.count >= 2 {
                        Text("사용하실 수 있는 닉네임입니다.")
                            .foregroundColor(Color("B1"))
                    } else {
                        Text("사용하실 수 없는 닉네임입니다.")
                            .foregroundColor(Color("R1"))
                    }
                }  else {
                        Text("사용하실 수 없는 닉네임입니다.")
                            .opacity(0)
                    }
                }
                
                
            Spacer()
                .frame(height: 30)
            
            
            //회원가입 버튼
            Button {
                //Save new user data
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("B1"))
                        .frame(width: 350, height: 54)
                    Text ("가입하기")
                        .foregroundColor(.white)
                }.padding(.top)
            }
            
            
            
        }.navigationTitle("회원가입")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                                    Button(action:{
                self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack{
                    Image(systemName: "chevron.left")
                        .foregroundColor(.gray)
                }
            }
            )
    }
}


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
