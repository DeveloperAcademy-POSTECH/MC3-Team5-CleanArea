//
//  AlbumView.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/14.
//

import SwiftUI

struct AlbumView: View {
	
	@State var toggleOn = true
	@StateObject var viewModel = AlbumViewModel()
	//	@ObservedObject var viewModel = AlbumViewModel()
	
	var body: some View {
		ScrollView(showsIndicators: false) {
			VStack {
				ScrollView(.horizontal, showsIndicators: false) {
					HStack {
						// ForEach(0..<viewModel.albums.users.count) 이게 아니라
						// 이렇게 처리해야하네..
						// 여기 들어가는 사진은 프로필사진 + 닉네임 + 역할로 가자 자기가 올린 사진을 썸네일로 하면 답없음
						ForEach(viewModel.albums.users.indices, id: \.self) { index in
							VStack {
								Rectangle()
									.fill(Color.purple)
									.cornerRadius(20)
									.frame(width: 70, height: 84)
									.padding(.all, 5)
									.overlay {
										RoundedRectangle(cornerRadius: 20)
											.stroke(Color.green, lineWidth: 2)
											.padding(2)
									}
									.overlay {
										// 여우 이미지
									}
								Text("\(viewModel.albums.users[index])")
									.font(.system(size: 12))
									.fontWeight(.bold)
								Text("\(viewModel.albums.users[index])")
									.font(.system(size: 12))
							}
						}
					}
				}
				.padding(.horizontal, 20)
				
				LazyVStack(pinnedViews: [.sectionHeaders]){
					Section {
						VStack(spacing: 4) {
							ForEach(viewModel.images.indices, id: \.self) { index in
								if toggleOn {
									if index % 3 == 1 {
										FirstFeedLayout(entitys: viewModel.images[index])
									} else {
										SecondFeedLayout(entitys: viewModel.images[index])
									}
								} else {
									GalleryLayout(entitys: viewModel.images[index])
								}
							}
						}
					} header: {
						HStack {
							Toggle(isOn: self.$toggleOn) {
								Text("All")
							}
							.padding(.horizontal)
						}
						.frame(height: 40)
						.background(Color.white)
					}
				}
			}
		}
		.onAppear {
			viewModel.fetchAlbumImages(albumDocId: "")
		}
	}
}

//struct AlbumView_Previews: PreviewProvider {
//	static var previews: some View {
//		AlbumView()
//	}
//}
