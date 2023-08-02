//
//  AlbumRoleSelectView.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/18.
//

import SwiftUI

struct AlbumRoleSelectView: View {
	
	@Environment(\.dismiss) var dismiss
	
	@StateObject var mainViewModel: MainViewModel
	
	@State private var isActive = false
	@State private var selectingFox = false
	@State private var selectedIndex: Int? = nil
	@State var newAlbum: Album
	
	var body: some View {
		VStack {
			HStack (spacing: 0){
				Rectangle()
					.frame(width: (UIScreen.width - 50)/3*2, height: 3)
					.padding(.top, 15)
					.foregroundColor(.mainColor)
				Rectangle()
					.frame(width: (UIScreen.width - 50)/3, height: 3)
					.padding(.top, 15)
					.foregroundColor(.mainColor)
					.opacity(0.1)
			}
			VStack(alignment: .leading){
				Text("여행에서 맡고 싶은 역할을")
				Text("선택해주세요")
			}
			.font(.system(size: 24, weight: .bold, design: .default))
			.foregroundColor(.black)
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding(.leading, 20)
			.padding(.top, 30)
			
			Spacer()
			
			LazyVGrid(columns: [
				.init(.flexible(), spacing: 2),
				.init(.flexible(), spacing: 2),
				.init(.flexible(), spacing: 2)
			], spacing: 30) {
				ForEach(0..<6, id: \.self) { id in
					FoxCardView(fox: foxs[id], isSelected: selectedIndex == id)
						.onTapGesture {
							selectedIndex = selectedIndex == id ? nil : id
						}
				}
			}
			
			Spacer()
			
			if selectedIndex != nil {
				NavigationLink {
					FindFriendView(mainViewModel: mainViewModel, newAlbum: self.newAlbum)
						.navigationBarBackButtonHidden()
				} label: {
					Rectangle()
						.frame(width: UIScreen.main.bounds.width - 30, height: 54)
						.foregroundColor(Color.mainColor)
						.cornerRadius(10)
						.overlay(Text("선택완료").font(.system(size: 18, weight: .bold, design: .default)).foregroundColor(Color.white))
						.padding(.bottom, 20)
				}
			} else {
				Rectangle()
					.frame(width: UIScreen.main.bounds.width - 30, height: 54)
					.foregroundColor(Color.unclicked)
					.cornerRadius(10)
					.overlay(Text("선택완료").font(.system(size: 18, weight: .bold, design: .default)).foregroundColor(Color.white))
					.padding(.bottom, 20)
			}
		}
		.navigationTitle(Text("역할 선택하기"))
		.navigationBarTitleDisplayMode(.inline)
		.background(Color.white)
		.modifier(BackToolBarModifier())
		.onChange(of: selectedIndex ?? 0, perform: { newValue in
			if newAlbum.role.isEmpty {
				newAlbum.role.append(foxs[newValue].foxImage)
			} else {
				newAlbum.role[0] = foxs[newValue].foxImage
			}
		})
	}
}
