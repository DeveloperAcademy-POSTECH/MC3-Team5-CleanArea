//
//  InvitationView.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/14.
//

import SwiftUI

struct TwoInvitationView: View {
	@Environment(\.dismiss) var dismiss
	var friend = "시저"
	var place = "포항 여행"
	@State private var opacityValues = [0.0, 0.0]
	let noti : Notification
	
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
						.frame(width: UIScreen.width/3-15, height: UIScreen.width/3-15)
						.foregroundColor(Color.white)
					//					Image(users[0].profileImageUrl)
					//						.resizable()
					//						.scaledToFill()
					//						.frame(width: UIScreen.width/3-21, height: UIScreen.width/3-21)
					//						.clipShape(Circle())
					
					Image("Pin")
						.resizable()
						.scaledToFill()
						.frame(width: UIScreen.width/3-21, height: UIScreen.width/3-21)
						.clipShape(Circle())
				}
				.opacity(opacityValues[0])
				.offset(x: -42)
				
				ZStack{
					Circle()
						.frame(width: UIScreen.width/3-15, height: UIScreen.width/3-15)
						.foregroundColor(Color.white)
					
					Image("Pin")
						.resizable()
						.scaledToFill()
						.frame(width: UIScreen.width/3-21, height: UIScreen.width/3-21)
						.clipShape(Circle())
					
					//					Image(users[1].profileImageUrl)
					//						.resizable()
					//						.scaledToFill()
					//						.frame(width: UIScreen.width/3-21, height: UIScreen.width/3-21)
					//						.clipShape(Circle())
				}
				.opacity(opacityValues[1])
				.offset(x: 40)
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
					RoleSelectView(noti: noti)
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
		}
	}
}
