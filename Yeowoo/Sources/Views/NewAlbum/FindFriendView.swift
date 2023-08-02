//
//  FindFriendView.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/18.
//

import SwiftUI

struct FindFriendView: View {
	
	@Environment(\.dismiss) var dismiss
	
	@EnvironmentObject var appState: AppState
	
	@StateObject var viewModel = FindFriendViewModel()
	@StateObject var mainViewModel: MainViewModel
	
	@State private var findUser: User = User()
	@State private var friendID: String = ""
	@State private var myFriend: [User] = []
	@State private var selectedFriends: [User] = []
	@State private var friendToggles: [Bool] = []
	@State var newAlbum: Album
	@State var showAlert = false
	
	var body: some View {
		VStack(alignment: .center){
			Rectangle()
				.frame(width: UIScreen.width - 50, height: 3)
				.padding(.top, 15)
				.foregroundColor(.mainColor)
			Text("친구 찾기")
				.font(.system(size: 18, weight: .bold, design: .default))
				.frame(maxWidth: .infinity, alignment: .leading)
				.foregroundColor(.friendGray)
				.padding(.top, 35)
				.padding(. leading, 30)
			
			ZStack {
				GrayTitleMakingView(text: $friendID, placeholder: "친구 아이디를 입력해주세요")
				HStack {
					Spacer()
						.frame(width: UIScreen.width - 110)
					Button {
						Task {
							findUser = try await viewModel.searchUser(parmUserId: friendID)
							if !myFriend.contains(where: { $0.id == findUser.id }) {
								myFriend.insert(findUser, at: 0)
								friendToggles.insert(false, at: 0)
							}
						}
					} label: {
						Image(systemName: "magnifyingglass")
							.resizable()
							.frame(width: 24, height: 24)
							.foregroundColor(.alarmGray)
					}
				}
			}
			.padding(.bottom, 20)
			
			ScrollView{
				ForEach(myFriend.indices, id: \.self) { index in
					FindFriendContents(friendToggle: $friendToggles[index], user: myFriend[index])
				}
				
				Spacer()
			}
			
			Button{
				selectedFriends = myFriend.indices.filter { friendToggles[$0] }.map { myFriend[$0] }
				newAlbum.users.append(contentsOf: selectedFriends.map { $0.docId })
				if !newAlbum.users.isEmpty {
					for _ in 0..<newAlbum.users.count - 1 {
						newAlbum.role.append("normalFox")
					}
				}
				Task {
					try await viewModel.createTravel(newAlbum: newAlbum)
					showAlert = true
					sendPushNotification(to: selectedFriends.map { $0.fcmToken }, title: "From \(UserDefaultsSetting.nickname)", body: "\(newAlbum.albumTitle)에 초대해요!")
				}
			} label: {
				Rectangle()
					.frame(width: UIScreen.main.bounds.width - 30, height: 54)
					.foregroundColor(Color.mainColor)
					.cornerRadius(10)
					.overlay(Text("여행 시작하기").font(.system(size: 18,
														  weight: .bold,
														  design: .default)).foregroundColor(Color.white))
					.padding(.bottom, 20)
			}
			.alert(isPresented: $showAlert) {
				Alert(title: Text("여행 생성 성공"), message: Text("이제 여행을 떠나볼까요?"),
					  dismissButton: .default(Text("확인"), action: {
					Task {
						mainViewModel.finishedFetch = false
						mainViewModel.openMake.toggle()
						try await mainViewModel.loadAlbum()
					}
				}))
			}
		}
		.navigationTitle(Text("친구 초대하기"))
		.navigationBarTitleDisplayMode(.inline)
		.background(.white)
		.modifier(BackToolBarModifier())
	}
}
