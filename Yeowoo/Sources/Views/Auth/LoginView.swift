//
//  LoginView.swift
//  Yeowoo
//
//  Created by Jisu Lee on 2023/07/16.
//

import SwiftUI

struct LoginView: View {
	@StateObject private var viewModel = AuthViewModel()
	
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	
	@State private var ID = ""
	@State private var password = ""
	
	@State var isLoggedIn: Bool = false
	@State var isShownPassword: Bool = true
	
	@State private var isAutoLogin = false
	@State private var isSavedID = false
	
	@State var showAlertFlag: Bool = false
	@State var showAlert: Bool = false
	
	var body: some View {
		
		VStack{
			//아이디 입력창
			TextField("아이디", text: $ID)
				.padding()
                .font(.custom16regular())
                .frame(width: UIScreen.getWidth(350), height: UIScreen.getHeight(46))
				.background(Color("G5"))
				.cornerRadius(10)
			
			//비밀번호 입력창
			ZStack(alignment: .trailing) {
				if isShownPassword{
					SecureField("비밀번호", text: $password)
						.padding()
                        .font(.custom16regular())
                        .frame(width: UIScreen.getWidth(350), height: UIScreen.getHeight(46))
						.background(Color("G5"))
						.cornerRadius(10)
				} else {
                    TextField("비밀번호", text: $password)
						.padding()
                        .font(.custom16regular())
                        .frame(width: UIScreen.getWidth(350), height: UIScreen.getHeight(46))
						.background(Color("G5"))
						.cornerRadius(10)
				}
                
				//입력시 비밀번호 보이기 및 감추기
				Button {
					isShownPassword.toggle()
				} label: {
					Image(systemName: isShownPassword ? "eye" : "eye.slash.fill")
						.foregroundColor(Color("G3"))
				}
				.padding()
			}
			
			Spacer()
			
			//로그인 버튼
			Button {
				Task {
					let chk = try await viewModel.signin(id: ID, pwd: password)
                    
					if chk {
						showAlertFlag = true
						showAlert = true
					} else {
						showAlertFlag = false
						showAlert = true
					}
				}
			} label: {
				ZStack{
					RoundedRectangle(cornerRadius: 10)
						.fill(Color("B1"))
                        .frame(width: UIScreen.getWidth(350), height: UIScreen.getHeight(54))
                    
					Text ("로그인")
                        .font(.custom18bold())
						.foregroundColor(.white)
				}
			}
		}
		.alert(isPresented: $showAlert) {
			if self.showAlertFlag {
				return Alert(title: Text("로그인 성공"), message: Text("로그인에 성공하였습니다."),
							 dismissButton: .default(Text("확인"), action: {
					let window = UIApplication
						.shared
						.connectedScenes
						.flatMap { ($0 as?
									UIWindowScene)?.windows ?? [] }
						.first { $0.isKeyWindow }
                    
					let appState = AppState()
                    
					window?.rootViewController = UIHostingController(
						rootView: MainView()
							.environmentObject(appState)
					)
                    
					window?.makeKeyAndVisible()
				}))
			} else {
				return Alert(title: Text("로그인 실패"),
                             message: Text("아이디 또는 비밀번호를 확인해주세요."),
							 dismissButton: .default(Text("확인")))
			}
		}
		.padding()
		.navigationTitle("로그인")
		.navigationBarTitleDisplayMode(.inline)
		.background(Color.white)
		.modifier(BackToolBarModifier())
	}
}
