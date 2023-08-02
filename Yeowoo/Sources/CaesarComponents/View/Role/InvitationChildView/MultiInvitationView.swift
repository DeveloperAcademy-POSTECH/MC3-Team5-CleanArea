//
//  InvitationView.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/14.
//

import SwiftUI

struct MultiInvitationView: View {
	@Environment(\.dismiss) var dismiss
	//	var friend = "제임스"
	//	var place = "제주도 여행"
	@State private var opacityValues = [0.0, 0.0, 0.0, 0.0]
    @StateObject var mainViewModel: MainViewModel
	let noti : Notification
	let users: [User]
//	var mockData: MockModel
	
	//참가한 사람 -3 사람 수 표시
	//	var number: Int = mockData.count
	
	var body: some View {
		VStack {
			HStack (spacing: 0){
				Rectangle()
					.frame(width: (UIScreen.width - 50)/2, height: 3)
					.padding(.top, 15)
					.foregroundColor(.mainColor)
				Rectangle()
					.frame(width: (UIScreen.width - 50)/2, height: 3)
					.padding(.top, 15)
					.foregroundColor(.mainColor)
					.opacity(0.1)
			}
			VStack(alignment: .leading){
				Text("\(noti.sendUserNickname)님이 초대한")
				Text(noti.travelTitle)
					.foregroundColor(.mainColor)
				+ Text("에 참가하실래요?")
			}
			.font(.system(size: 24, weight: .bold, design: .default))
			.foregroundColor(.black)
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding(.leading, 20)
			.padding(.top, 30)
			
			Spacer()
				.frame(height: 172)
			//초대된 사람들(나중에 카드로 뺄 예정)
			ZStack(alignment: .center){
				ZStack{
					Circle()
						.frame(width: UIScreen.width/3-30, height: UIScreen.width/3-30)
						.foregroundColor(Color.white)

					CacheAsyncImage(url: URL(string: users[0].profileImage == "" ? "https://firebasestorage.googleapis.com/v0/b/yeowoo-186cd.appspot.com/o/Album%2FmockImage.png?alt=media&token=c824dbe8-cd1c-459f-b27a-b756dcac4e84" : users[0].profileImage)!) { phase in
						switch phase {
						case .success(let image):
							image
								.resizable()
								.scaledToFill()
								.frame(width: UIScreen.width/3-36, height: UIScreen.width/3-36)
								.clipShape(Circle())
						default:
							ProgressView()
								.frame(width: UIScreen.width/3-36, height: UIScreen.width/3-36)
						}
					}
				}
				.opacity(opacityValues[0])
				.offset(x: -70)
				
				ZStack{
					Circle()
						.frame(width: UIScreen.width/3-30, height: UIScreen.width/3-30)
						.foregroundColor(Color.white)

					CacheAsyncImage(url: URL(string: users[1].profileImage == "" ? "https://firebasestorage.googleapis.com/v0/b/yeowoo-186cd.appspot.com/o/Album%2FmockImage.png?alt=media&token=c824dbe8-cd1c-459f-b27a-b756dcac4e84" : users[1].profileImage)!) { phase in
						switch phase {
						case .success(let image):
							image
								.resizable()
								.scaledToFill()
								.frame(width: UIScreen.width/3-36, height: UIScreen.width/3-36)
								.clipShape(Circle())
						default:
							ProgressView()
								.frame(width: UIScreen.width/3-36, height: UIScreen.width/3-36)
						}
					}

				}
				.opacity(opacityValues[1])
				ZStack{
					Circle()
						.frame(width: UIScreen.width/3-30, height: UIScreen.width/3-30)
						.foregroundColor(Color.white)
					CacheAsyncImage(url: URL(string: users[2].profileImage == "" ? "https://firebasestorage.googleapis.com/v0/b/yeowoo-186cd.appspot.com/o/Album%2FmockImage.png?alt=media&token=c824dbe8-cd1c-459f-b27a-b756dcac4e84" : users[2].profileImage)!) { phase in
						switch phase {
						case .success(let image):
							image
								.resizable()
								.scaledToFill()
								.frame(width: UIScreen.width/3-36, height: UIScreen.width/3-36)
								.clipShape(Circle())
						default:
							ProgressView()
								.frame(width: UIScreen.width/3-36, height: UIScreen.width/3-36)
						}
					}

				}
				.opacity(opacityValues[2])
				.offset(x: 70)
				
				if noti.userDocIds.count == 3 {
					//3명일때는 안뜨도록
					
				} else {
					ZStack{
						Circle()
							.frame(width: 40, height: 40)
							.foregroundColor(Color.white)
						Circle()
							.frame(width: 34, height: 34)
							.foregroundColor(Color.whiteGray)
						Text("+\(noti.userDocIds.count - 3)")
							.foregroundColor(.noGray)
							.font(.system(size: 20, weight: .bold, design: .default))
					}
					.opacity(opacityValues[3])
					.offset(x: 120, y: 30)
				}
			}
			
			Spacer()
			
			// 버튼
			HStack {
				Button{
					dismiss()
				} label: {
					Rectangle()
						.frame(width: UIScreen.main.bounds.width/2 - 30, height: 54)
						.foregroundColor(Color.whiteGray)
						.cornerRadius(10)
						.overlay(Text("아니요").font(.system(size: 18, weight: .bold, design: .default)).foregroundColor(Color.noGray))
				}
				NavigationLink{
					//참여 로직
                    RoleSelectView(noti: self.noti, mainViewModel: mainViewModel)
						.navigationBarBackButtonHidden()
					
				} label: {
					Rectangle()
						.frame(width: UIScreen.main.bounds.width/2 - 30, height: 54)
						.foregroundColor(Color.mainColor)
						.cornerRadius(10)
						.overlay(Text("참가할게요").font(.system(size: 18, weight: .bold, design: .default)).foregroundColor(Color.white))
				}
				
			}
			.padding(.bottom, 20)
		}
		.background(Color.white)
		.modifier(BackToolBarModifier())
		.onAppear {
			withAnimation(Animation.easeIn(duration: 1.0).delay(0.5)) {
				self.opacityValues[0] = 1.0
			}
			withAnimation(Animation.easeIn(duration: 1.0).delay(1.0)) {
				self.opacityValues[1] = 1.0
			}
			withAnimation(Animation.easeIn(duration: 1.0).delay(1.5)) {
				self.opacityValues[2] = 1.0
			}
			withAnimation(Animation.easeIn(duration: 1.0).delay(2.0)) {
				self.opacityValues[3] = 1.0
			}
		}
	}
}
