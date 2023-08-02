//
//  SettingView.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/14.
//

import SwiftUI

struct SettingView: View {
	
	@Environment(\.dismiss) var dismiss
	
	@EnvironmentObject var appState: AppState
	
	@ObservedObject private var viewModel = SettingViewModel()
	@StateObject var mainViewModel: MainViewModel
	
	@State private var showLoginCoverView = false
	@State private var cameraToggle = true
	@State private var withdrawalAccount = false
	@State private var loggingOutSheet = false
	
	var userInfo: User
	
	var body: some View {
		VStack{
			VStack{
				Text("프로필")
					.modifier(SubTitleFont())
				NavigationLink{
					ProfileSettingView(mainViewModel: mainViewModel, viewModel: self.viewModel, userInfo: userInfo)
						.navigationBarBackButtonHidden()
				}label: {
					HStack{
						CacheAsyncImage(url: URL(string: userInfo.profileImage)!) { phase in
							switch phase {
							case .success(let image):
								image
									.resizable()
									.scaledToFill()
									.frame(width: 64, height: 64)
									.background(Color.mainColor)
									.clipShape(Circle())
									.padding(.horizontal, 10 )
							default:
								ProgressView()
									.frame(width: 64, height: 64)
							}
						}
						HStack{
							VStack(alignment: .leading){
								Text(userInfo.nickname)
									.font(.headline)
								Text(userInfo.id)
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
						
						Toggle("", isOn: $cameraToggle)
							.toggleStyle(SwitchToggleStyle(tint: Color.mainColor))
							.padding(.trailing, 20)
					}
				}
				.modifier(CardViewModifier())
			}
			
			Spacer()
			
			VStack(spacing: 0){
				Button{
					withdrawalAccount = true
				} label: {
					ZStack {
						RoundedRectangle(cornerRadius: 10)
							.fill(Color.whiteGray)
							.frame(width: 350, height: 54)
						Text ("회원 탈퇴")
							.font(.system(size: 18, weight: .bold, design: .default))
							.foregroundColor(Color.warningRed)
					}.padding(.top)
				}
				.alert(isPresented: $withdrawalAccount) {
					Alert(
						title: Text("회원 탈퇴"),
						message: Text("탈퇴시 사진 복구가 불가능합니다. 정말 탈퇴하시겠습니까?"),
						primaryButton: .destructive(Text("탈퇴")
							.foregroundColor(.warningRed),
													action: {
														do {
															try KeyChainManager.shared.delete(
																account: .documentId
															)
															UserDefaultsSetting.userDocId = ""
															Task {
																try await viewModel.withdrawalUser()
																showLoginCoverView = true
															}
														} catch {
															print(KeyChainError.itemNotFound)
														}
													}),
						secondaryButton: .cancel(Text("취소"))
					)
				}
				.background(
					NavigationLink("",
								   destination: LoginCoverView().navigationBarBackButtonHidden(),
								   isActive: $showLoginCoverView)
				)
				Button{
					loggingOutSheet = true
				} label: {
					ZStack {
						RoundedRectangle(cornerRadius: 10)
							.fill(Color.whiteGray)
							.frame(width: 350, height: 54)
						Text ("로그아웃")
							.font(.system(size: 18, weight: .bold, design: .default))
					}.padding(.top)
				}
				.actionSheet(isPresented: $loggingOutSheet) {
					ActionSheet(title: Text("로그아웃"),
								message: Text("정말로 로그아웃하시겠습니까?"),
								buttons: [
									.destructive(Text("로그아웃")) {
										do {
											print("logout do")
											try KeyChainManager.shared.delete(account: .documentId)
											UserDefaultsSetting.userDocId = ""
											showLoginCoverView = true
										} catch {
											print(KeyChainError.itemNotFound)
										}
									},
									.cancel(Text("취소"))
								])
				}
				.background(
					NavigationLink("",
								   destination: LoginCoverView().navigationBarBackButtonHidden(),
								   isActive: $showLoginCoverView)
				)
			}
		}
		.navigationTitle("설정")
		.navigationBarTitleDisplayMode(.inline)
		.background(Color.white)
		.modifier(BackToolBarModifier())
		.accentColor(.black)
	}
}
