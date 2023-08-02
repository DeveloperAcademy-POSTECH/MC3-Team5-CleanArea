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
	
	@EnvironmentObject var appState: AppState
	
	@StateObject var mainViewModel: MainViewModel
	@ObservedObject var viewModel: SettingViewModel
	
	@State private var selectedImage: PhotosPickerItem?
	@State private var nickName = ""
	@State private var identity = ""
	@State private var sameID: Bool? = nil
	@State private var changedProfileImage = false
	@State private var changedProfileImageData: Data?
	
	var userInfo: User
	
	var body: some View {
		VStack(alignment: .center){
			PhotosPicker(selection: $selectedImage) {
				ZStack{
					if changedProfileImageData == nil {
						CacheAsyncImage(url: URL(string: userInfo.profileImage)!) { phase in
							switch phase {
							case .success(let image):
								image
									.resizable()
									.scaledToFill()
									.frame(width: 130, height: 130)
									.background(Color.mainColor)
									.clipShape(Circle())
									.padding(.horizontal, 10)
							default:
								ProgressView()
									.frame(width: 130, height: 130)
							}
						}
					} else {
						if let uiImage = UIImage(data: changedProfileImageData!) {
							Image(uiImage: uiImage)
								.resizable()
								.scaledToFill()
								.frame(width: 130, height: 130)
								.background(Color.mainColor)
								.clipShape(Circle())
								.padding(.horizontal, 10)
						}
					}
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
			.onChange(of: selectedImage) { newVal in
				Task {
					if let data = try? await newVal?.loadTransferable(type: Data.self) {
						changedProfileImageData = data
					}
				}
			}
			
			EditProfileRowView(text: $nickName, Profile: "닉네임", placeholder: "닉네임을 써주세요")
			
			ZStack(alignment: .trailing) {
				EditProfileRowView(text: $identity, Profile: "아이디", placeholder: "아이디를 써주세요")
					.onChange(of: identity) { _ in
						viewModel.textFieldEditing()
					}
				Button{
					Task {
						try await viewModel.idDuplicateCheck(id: identity)
					}
				} label: { Text("중복확인")
						.font(.system(size: 14, weight: .semibold, design: .default))
						.foregroundColor(.white)
						.padding(.horizontal, 10)
						.padding(.vertical, 5)
						.cornerRadius(10)
						.background(
							RoundedRectangle(cornerRadius: 10)
								.fill(Color(viewModel.idDuplicateCheckFlag == .pass ? "G4" : "B1")))
				}
				.padding(.trailing, 10)
			}
			HStack {
				Text(
					viewModel.idDuplicateCheckFlag == .none ? "" :
						viewModel.idDuplicateCheckFlag == .pass ? "사용하실 수 있는 아이디입니다." :
						"사용하실 수 없는 아이디입니다."
				)
				.font(.footnote)
				.foregroundColor(viewModel.idDuplicateCheckFlag == .pass ? Color.mainColor : Color.warningRed)
				.padding(.leading, 32)
				.padding(.top, 10)
				Spacer()
			}
			
			Spacer()
			
			Button{
				Task {
					if selectedImage == nil {
						try await viewModel.updateProfile(nickName: nickName, id: identity)
						dismiss()
					} else {
						if let data = try? await selectedImage?.loadTransferable(type: Data.self) {
							try await viewModel.updateProfile(imageData: data,
															  nickName: nickName, id: identity)
							viewModel.idDuplicateCheckFlag = .none
						}
						mainViewModel.finishedFetch = false
						mainViewModel.openSetting.toggle()
						try await mainViewModel.loadAlbum()
					}
				}
			} label: {
				ZStack {
					RoundedRectangle(cornerRadius: 10)
						.foregroundColor(viewModel.idDuplicateCheckFlag == .pass && nickName.count >= 2
										 ? Color.mainColor : Color.mainColor.opacity(0.2))
						.frame(height: UIScreen.getHeight(54))
						.padding([.leading, .trailing], UIScreen.getWidth(20))
					Text("저장하기")
						.font(.custom18semibold())
						.foregroundColor(.white)
				}
			}
		}
		.onAppear {
			nickName = userInfo.nickname
		}
		.navigationTitle("프로필 수정하기")
		.navigationBarTitleDisplayMode(.inline)
		.background(Color.white)
		.modifier(BackToolBarModifier())
	}
}
