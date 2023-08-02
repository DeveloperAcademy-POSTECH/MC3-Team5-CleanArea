//
//  InviteFriendView.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/08/01.
//

import SwiftUI

struct InviteFriendView: View {
	
	@StateObject var viewModel = FindFriendViewModel()
	@Environment(\.dismiss) var dismiss
	
	@State var findUser: User = User()
	@State var friendID: String = ""
	@State var myFriend: [User] = []
	@State var selectedFriends: [User] = []
	@State var friendToggles: [Bool] = []
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
						// 유저 찾기
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
				
				print("@@@ \(newAlbum.users)")
				
				newAlbum.users.append(contentsOf: selectedFriends.map { $0.docId })
				print("@@@ \(newAlbum.users)")
				
				if !newAlbum.users.isEmpty {
					for _ in 0..<newAlbum.users.count - 1 {
						newAlbum.role.append("normalFox")
					}
				}
				
				// 여행 생성
				Task {
//					try await viewModel.createTravel(newAlbum: newAlbum)
					try await viewModel.inviteFriend(album: newAlbum, inviteUsers: selectedFriends)
					showAlert = true
					
					// 여기 알림 보내기
					
//					let tokens = ["cBQ7l9axn0q7gb3AYab9jf:APA91bGZ3xRKQVgGI5V084qArYZKXON8ypDx_jBqbpNXpQPxgCbJlM-MH3uEZ1eR5LBjyhB063ofEY0QBdpDIgm1k2NY8AcSCx1ZBnc24-xRKDxt0Qz_9GBaWD5H4dftIiBW5bCKU-Zw"]
					
//					sendPushNotification(to: tokens, title: "From \(UserDefaultsSetting.nickname)", body: "\(newAlbum.albumTitle)에 초대해요!")
					
					sendPushNotification(to: selectedFriends.map { $0.fcmToken }, title: "From \(UserDefaultsSetting.nickname)", body: "\(newAlbum.albumTitle)에 초대해요!")
					
//					sendPushNotification(to: [testToken], title: "From \(UserDefaultsSetting.nickname)", body: "\(newAlbum.albumTitle)에 초대해요!")
					
				
				}
			} label: {
				Rectangle()
					.frame(width: UIScreen.main.bounds.width - 30, height: 54)
					.foregroundColor(Color.mainColor)
					.cornerRadius(10)
					.overlay(Text("초대하기").font(.system(size: 18, weight: .bold, design: .default)).foregroundColor(Color.white))
					.padding(.bottom, 20)
			}
			.alert(isPresented: $showAlert) {
				Alert(title: Text("초대하기 성공"), message: Text("여행을 계속 즐겨봐요!"),
					  dismissButton: .default(Text("확인"), action: {
					dismiss()
				}))
			}
		}
		.navigationTitle(Text("친구 초대하기"))
		.navigationBarTitleDisplayMode(.inline)
		.background(.white)
		.modifier(BackToolBarModifier())
	}
}

