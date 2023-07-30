//
//  InvitationView.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/19.
//

import SwiftUI

struct MockModel {
	let sendDate: String
	let albumId: String
	let sendUserNickName: String
	let travelTitle: String
	let belongUsersProfileUrl: [String]
}

struct InvitationView: View {
	//유저 인원수 받기
	//	@State var invitedFriends: [SubUser] = [users[0], users[1]]
	
	let noti : Notification
	
	var body: some View {
		
		//		MultiInvitationView(mockData: MockModel(sendDate: "2023.07.27",
		//												albumId: "GQAPDJeFgTtz9V3LeuFe",
		//												sendUserNickName: "성훈",
		//												travelTitle: "울릉도",
		//												belongUsersProfileUrl: ["https://firebasestorage.googleapis.com/v0/b/yeowoo-186cd.appspot.com/o/album1%2F4.jpeg?alt=media&token=c04395d8-0249-4372-bf5d-38c42501bb62",
		//																		"https://firebasestorage.googleapis.com/v0/b/yeowoo-186cd.appspot.com/o/album1%2F8.jpeg?alt=media&token=6cc55e83-17c4-42ef-9a2e-887d21ca817b",
		//																		""]))
		//		.onAppear {
		//			UserDefaultsSetting.userDocId = "Mt5DPoKI4Im0vZfq9vOl"
		//		}
		//
		
		// 추후 수정
		MultiInvitationView(noti: noti)
		
//		if noti.userDocIds.count < 3 {
//			TwoInvitationView()
//				.onAppear {
//					UserDefaultsSetting.userDocId = "Mt5DPoKI4Im0vZfq9vOl"
//					//					Task {
//					//						try await FirebaseService.participateTravel(albumDocId: "GQAPDJeFgTtz9V3LeuFe", role: "testFox")
//					//					}
//				}
//		} else {
//			MultiInvitationView(noti: noti)
////			.onAppear {
////				UserDefaultsSetting.userDocId = "Mt5DPoKI4Im0vZfq9vOl"
////			}
//		}
	}
}
