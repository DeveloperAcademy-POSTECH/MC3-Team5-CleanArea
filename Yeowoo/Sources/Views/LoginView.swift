//
//  LoginView.swift
//  Yeowoo
//
//  Created by Jisu Lee on 2023/07/16.
//

import SwiftUI

struct LoginView: View {
    @State private var ID = ""
    @State private var password = ""
    
    @State var isLoggedIn: Bool = false
    @State var isShownPassword: Bool = false
    
    @State private var isAutoLogin = false
    @State private var isSavedID = false
    
    var body: some View {
        NavigationView{
            VStack{
                
                Text("로그인")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding()
                
                //아이디 입력창
                TextField("아이디", text: $ID)
                    .padding()
                    .frame(width: 350, height: 46)
                    .background(Color("G5"))
                    .cornerRadius(10)
                
                //비밀번호 입력창
                ZStack(alignment: .trailing) {
                    if isShownPassword{
                        SecureField("비밀번호", text: $password)
                            .padding()
                            .frame(width: 350, height: 46)
                            .background(Color("G5"))
                            .cornerRadius(10)
                    } else { TextField("비밀번호", text: $password)
                            .padding()
                            .frame(width: 350, height: 46)
                            .background(Color("G5"))
                            .cornerRadius(10)
                    }
                    //입력시 비밀번호 보이기 및 감추기
                    Button {
                        //수정~~~~~~~~~~~~~~~
                        isShownPassword.toggle()
                    } label: {
                        Image(systemName: isShownPassword ? "eye" : "eye.slash.fill")
                            .foregroundColor(Color("G3"))
                    }
                    .padding()
                }
//                }
                
                //자동로그인 및 아이디 저장 체크박스
                HStack {
                    Toggle("자동 로그인", isOn: $isAutoLogin)
                        .toggleStyle(CheckboxToggleStyle())
                    Toggle("아이디 저장", isOn: $isSavedID)
                        .toggleStyle(CheckboxToggleStyle())
                }
                
                Spacer()
                
                //로그인 버튼
                Button("로그인"){
                    //Authenticate user
                }
                .foregroundColor(.white)
                .frame(width: 350, height: 54)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                    .fill(Color("B1")))
            }.padding()
        }
    }
}

//자동로그인 및 아이디 저장 토글
struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {configuration.isOn.toggle() }) {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle.fill")
                        .foregroundColor(configuration.isOn ? .black : Color("G5"))
                configuration.label
                        .foregroundColor(Color("G2"))
                     }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
