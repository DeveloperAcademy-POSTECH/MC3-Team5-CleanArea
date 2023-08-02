//
//  NotiCardContentsView.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/14.
//

import SwiftUI

struct NotiCardContentsView: View {
	
	let notis : Notification
    @StateObject var mainViewModel: MainViewModel
	@State private var showAlert = false
	@State private var showNavi = false
	
	@State var users: [User] = []
	
	// 이미 합류한 여행이면 뷰로 못넘어가게 로직 추가
	var body: some View {
		if !notis.isParticipateChk {
			NavigationLink {
                InvitationView(mainViewModel: mainViewModel,
							   notification: notis, users: users)
					.navigationBarBackButtonHidden()
			} label: {

				if users.isEmpty {
					ProgressView()
						.frame(width: 42, height: 42)
				} else {
					CacheAsyncImage(url: URL(string: users.first!.profileImage)!) { phase in
						switch phase {
						case .success(let image):
							image
								.resizable()
								.scaledToFill()
								.frame(width: 42, height: 42)
								.clipShape(Circle())
								.padding(.horizontal, 12 )
						default:
							ProgressView()
								.frame(width: 42, height: 42)
						}
					}

				}
				
				

				
				HStack{
					VStack(alignment: .leading){
						Text("From. \(notis.sendUserNickname)").font((.system(size: 12, weight: .semibold, design: .default)))
							.foregroundColor(.gray)
						Text("\(notis.travelTitle)에 초대해요!")
							.font((.system(size: 15, weight: .regular, design: .default)))
							.foregroundColor(.black)
					}
					
					Spacer()
					
					Image(systemName: "chevron.right")
						.imageScale(.large)
						.foregroundColor(.gray)
						.opacity(0.3)
						.padding(.trailing, 20)
				}
			}
			.onAppear {
				Task {
					self.users = try await FirebaseService.fetchUser(userDocIds: notis.userDocIds)
				}
			}
		} else {
			HStack {
				
				if users.isEmpty {
					ProgressView()
						.frame(width: 42, height: 42)
				} else {
					CacheAsyncImage(url: URL(string: users.first!.profileImage)!) { phase in
						switch phase {
						case .success(let image):
							image
								.resizable()
								.scaledToFill()
								.frame(width: 42, height: 42)
								.clipShape(Circle())
								.padding(.horizontal, 12 )
						default:
							ProgressView()
								.frame(width: 42, height: 42)
						}
					}

				}
				
				HStack{
					VStack(alignment: .leading){
						Text("From. \(notis.sendUserNickname)").font((.system(size: 12, weight: .semibold, design: .default)))
							.foregroundColor(.gray)
						Text("\(notis.travelTitle)에 초대해요!")
							.font((.system(size: 15, weight: .regular, design: .default)))
							.foregroundColor(.black)
					}
					
					Spacer()
					
					Image(systemName: "chevron.right")
						.imageScale(.large)
						.foregroundColor(.gray)
						.opacity(0.3)
						.padding(.trailing, 20)
				}
			}
		}
	}
}
