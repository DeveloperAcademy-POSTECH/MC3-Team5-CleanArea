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
	//    var myImage: String
	var userInfo: User
	
	@State private var selectedImage: PhotosPickerItem?
	@State private var nickName = ""
	@State private var identity = ""
	@State private var sameID:Bool? = nil
	@State private var changedProfileImage = false
	@State private var changedProfileImageData: Data?
	
	@ObservedObject var viewModel: SettingViewModel
	
	var body: some View {
		VStack(alignment: .center){
			
			//selecting profile picture (사진 수정 버튼)
			PhotosPicker(selection: $selectedImage) {
				ZStack{
					// 내사진
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
						if let uiImage = UIImage(data: changedProfileImageData!) { // 선택된 이미지가 있는 경우
							Image(uiImage: uiImage) // 선택된 이미지를 사용하여 이미지 표시
								.resizable()
								.scaledToFill()
								.frame(width: 130, height: 130)
								.background(Color.mainColor)
								.clipShape(Circle())
								.padding(.horizontal, 10)
						}
					}
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
			.onChange(of: selectedImage) { newVal in
				Task {
					if let data = try? await newVal?.loadTransferable(type: Data.self) {
						//					try await viewModel.updateProfile(imageData: data, nickName: nickName, id: identity)
						changedProfileImageData = data
					}
				}
			}
			
			//닉네임 변경란
			EditProfileRowView(Profile: "닉네임", placeholder: "닉네임을 써주세요", text: $nickName)
			
			//아이디 변경란
			ZStack(alignment: .trailing) {
				EditProfileRowView(Profile: "아이디", placeholder: "아이디를 써주세요", text: $identity)
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
							try await viewModel.updateProfile(imageData: data, nickName: nickName, id: identity)
							viewModel.idDuplicateCheckFlag = .none
							
							// 이거 후에 user fetch 해야함. 머지후에 핀이랑 이야기해서 추가하기
							dismiss()
						}
					}
				}
			} label: {
				ZStack {
					RoundedRectangle(cornerRadius: 10)
						.foregroundColor(viewModel.idDuplicateCheckFlag == .pass && nickName.count >= 2 ? Color.mainColor : Color.mainColor.opacity(0.2))
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
