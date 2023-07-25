//
//  SignUpView.swift
//  Yeowoo
//
//  Created by Jisu Lee on 2023/07/17.
//

import SwiftUI

struct SignUpView: View {
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@Environment(\.dismiss) private var dismiss
	
	@StateObject private var viewModel = AuthViewModel()
	
	// 택스트필드가 비어있다. 안비어있다 확인하는 프로퍼티 -> 중복확인 on off
	@State private var ID = ""
	
	// 비밀번호 일치 불일치 확인하는 프로퍼티
	@State private var password = ""
	@State private var doublePassword = ""
	
	// 닉네임 사용 가능하다 아니다 확인하는 프로퍼티
	@State private var nickname = ""
	
	@State var isShownPassword: Bool = true
	@State var isShownDoublePassword: Bool = true
	
	@State var showAlertFlag: Bool = false
	@State var showAlert: Bool = false
	
	var body: some View {
		VStack {
			Spacer()
				.frame(height: 35)
			
			//아이디
			VStack(alignment: .leading){
				//아이디
				Text("아이디")
					.font(.system(size: 18))
					.fontWeight(.bold)
					.padding(.leading, 8)
				
				ZStack(alignment: .trailing){
					//아이디 입력창
					TextField("아이디를 입력하세요", text: $ID)
						.font(.system(size: 16))
						.padding()
						.frame(width: 350, height: 46)
						.background(Color("G5"))
						.cornerRadius(10)
						.onChange(of: ID) { _ in
							viewModel.textFieldEditing()
						}
					
					//중복확인 버튼
					Button(action: {
						Task {
							try await viewModel.idDuplicateCheck(id: self.ID)
						}
					}) {
						Text("중복확인")
							.fontWeight(.semibold)
							.font(.system(size: 14))
							.foregroundColor(.white)
							.frame(width: 69, height: 24)
							.background(
								RoundedRectangle(cornerRadius: 10)
									.fill(Color(viewModel.idDuplicateCheckFlag == .pass ? "G4" : "B1")))
					}
					.disabled(viewModel.idDuplicateCheckFlag == .pass ? true : false)
					.padding(10)
				}
				
				//** 아이디 확인 메시지
				Text(
					viewModel.idDuplicateCheckFlag == .none ? "" :
						viewModel.idDuplicateCheckFlag == .pass ? "사용하실 수 있는 아이디입니다." :
						"사용하실 수 없는 아이디입니다."
				)
				.font(.system(size: 14))
				.foregroundColor(Color(
					viewModel.idDuplicateCheckFlag == .pass ? "mainColor" : "R1"
				))
				Spacer()
					.frame(height: 30)
			}
			
			//비밀번호
			VStack(alignment: .leading){
				//비밀번호
				Text("비밀번호")
					.font(.system(size: 18))
					.fontWeight(.bold)
					.padding(.leading, 8)
				
				//비밀번호 입력창
				ZStack(alignment: .trailing) {
					if isShownPassword{
						SecureField("비밀번호를 입력하세요", text: $password)
							.font(.system(size: 16))
							.padding()
							.frame(width: 350, height: 46)
							.background(Color("G5"))
							.cornerRadius(10)
					} else { TextField("비밀번호를 입력하세요", text: $password)
							.font(.system(size: 16))
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
					if isShownDoublePassword{
						SecureField("비밀번호를 다시 입력해주세요", text: $doublePassword)
							.padding()
							.frame(width: 350, height: 46)
							.background(Color("G5"))
							.cornerRadius(10)
					} else { TextField("비밀번호를 다시 입력해주세요", text: $doublePassword)
							.padding()
							.frame(width: 350, height: 46)
							.background(Color("G5"))
							.cornerRadius(10)
					}
					//입력시 비밀번호 보이기 및 감추기
					Button {
						isShownDoublePassword.toggle()
					} label: {
						Image(systemName: isShownDoublePassword ? "eye.slash.fill" : "eye")
							.foregroundColor(Color("G3"))
					}
					.padding()
				}
				
				//비밀번호 확인 메시지
				if password == "" && doublePassword == "" {
					Text("비밀번호가 일치합니다")
						.font(.system(size: 14))
						.opacity(0)
				} else if password == doublePassword {
					Text("비밀번호가 일치합니다")
						.font(.system(size: 14))
						.foregroundColor(Color("B1"))
				} else {
					Text("비밀번호가 일치하지 않습니다")
						.font(.system(size: 14))
						.foregroundColor(Color("R1"))
				}
				
				Spacer()
					.frame(height: 30)
			}
			
			//닉네임
			VStack(alignment: .leading){
				
				//닉네임
				Text("닉네임")
					.font(.system(size: 18))
					.fontWeight(.bold)
					.padding(.leading, 8)
				
				//닉네임 입력창
				TextField("두 글자 이상으로 된 닉네임", text: $nickname)
					.font(.system(size: 16))
					.padding()
					.frame(width: 350, height: 46)
					.background(Color("G5"))
					.cornerRadius(10)
				
				//닉네임 확인 메시지
				if !nickname.isEmpty {
					if nickname.count >= 2 {
						Text("사용하실 수 있는 닉네임입니다.")
							.font(.system(size: 14))
							.foregroundColor(Color("B1"))
					} else {
						Text("사용하실 수 없는 닉네임입니다.")
							.font(.system(size: 14))
							.foregroundColor(Color("R1"))
					}
				}  else {
					Text("사용하실 수 없는 닉네임입니다.")
						.font(.system(size: 14))
						.opacity(0)
				}
			}
			Spacer()
			//회원가입 버튼
			Button {
				Task {
					if try await self.viewModel.signup(id: self.ID, pwd: self.password,
													   nickname: self.nickname) {
						// 회원가입 성공
						self.showAlertFlag = true
						self.showAlert = true
					} else {
						// 회원가입 실패
						self.showAlertFlag = false
						self.showAlert = true
					}
				}
			} label: {
				ZStack {
					RoundedRectangle(cornerRadius: 10)
						.fill(Color("B1"))
						.opacity(viewModel.idDuplicateCheckFlag == .pass &&
								 password == doublePassword && nickname.count >= 2 ? 1 : 0.2)
						.frame(width: 350, height: 54)
					Text ("가입하기")
						.foregroundColor(.white)
						.font(.system(size: 18))
						.fontWeight(.bold)
				}.padding(.top)
			}
			.disabled(viewModel.idDuplicateCheckFlag == .pass &&
					  password == doublePassword && nickname.count >= 2 ? false : true)
			.alert(isPresented: $showAlert) {
				if self.showAlertFlag {
					return Alert(title: Text("회원가입 성공"), message: Text("회원가입에 성공하였습니다."),
								 dismissButton: .default(Text("확인"), action: {
						dismiss()
					}))
				} else {
					return Alert(title: Text("회원가입 실패"), message: Text("회원가입에 실패하였습니다."),
								 dismissButton: .default(Text("확인")))
				}
			}
		}.navigationTitle("회원가입")
			.navigationBarBackButtonHidden(true)
			.navigationBarItems(leading: Button(action:{
				self.presentationMode.wrappedValue.dismiss()
			}) {
				HStack{
					Image(systemName: "chevron.left")
						.foregroundColor(.gray)
				}
			})
			.onTapGesture {
				self.endTextEditing()
			}
	}
}
