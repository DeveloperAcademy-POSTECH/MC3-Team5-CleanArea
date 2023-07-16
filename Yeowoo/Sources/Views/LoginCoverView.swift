//
//  LoginCoverView.swift
//  Yeowoo
//
//  Created by Jisu Lee on 2023/07/16.
//

import SwiftUI

struct LoginCoverView: View {
    var body: some View {
        VStack{
            Image("여우")
                .resizable()
                .scaledToFit()
                .frame(width: 244, height: 119.29)
            Image("logincover")
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 240)
            
            Button {
                //move to LoginView
            } label: {
                Text("로그인")
                    .foregroundColor(.white)
                    .frame(width: 350, height: 54)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("B1")))
                        }
            Button {
                //move to SignupView
            } label: {
                Text("회원가입")
                    .foregroundColor(.black)
                    .frame(width: 350, height: 54)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("G6")))
                        }
        }
        
    }
}

struct LoginCoverView_Previews: PreviewProvider {
    static var previews: some View {
        LoginCoverView()
    }
}
