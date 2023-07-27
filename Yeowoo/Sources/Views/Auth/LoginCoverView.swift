//
//  LoginCoverView.swift
//  Yeowoo
//
//  Created by Jisu Lee on 2023/07/16.
//

import SwiftUI

struct LoginCoverView: View {
	@EnvironmentObject var appState: AppState
	@State var isViewActive: Bool = false
	@State var userInfo = User()
	
	var body: some View {
		NavigationStack {
			ZStack {
				VStack(alignment: .center, spacing: 0) {
					Image("loginLogo")
				}
				
				Button {
					isViewActive = true
				} label: {
					Text("로그인")
						.font(.system(size: 18))
						.fontWeight(.semibold)
						.foregroundColor(.white)
						.frame(width: 350, height: 54)
						.background(
							RoundedRectangle(cornerRadius: 10)
								.fill(Color("B1")))
				}
				.navigationDestination(isPresented: $isViewActive, destination: {
					SettingView(userInfo: $userInfo)
				})
				.onReceive(self.appState.$moveToRootView) { moveToDashboard in
					if moveToDashboard {
						self.isViewActive = false
						self.appState.moveToRootView = false
					}
				}
				.padding(.top, 320)
				
				NavigationLink(destination: SignUpView()) {
					Text("회원가입")
						.font(.system(size: 18))
						.fontWeight(.semibold)
						.foregroundColor(.black)
						.frame(width: 350, height: 54)
						.background(
							RoundedRectangle(cornerRadius: 10)
								.fill(Color("G6")))
				}
				.ignoresSafeArea(.keyboard)
				.padding(.top, 440)
			}
		}
	}
}
