//
//  AlbumView.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/14.
//

import SwiftUI

enum AlbumState {
	case user
	case all
}

struct AlbumView: View {
	
	let albumDocId: String
	
	@State var roleState: AlbumState = .all
	@State var toggleOn = true
	@State var albumState: AlbumState = .all
	@StateObject var viewModel = AlbumViewModel()
	
	var body: some View {
		ScrollView(showsIndicators: false) {
			VStack {
				ScrollView(.horizontal, showsIndicators: false) {
					HStack {
						// ForEach(0..<viewModel.albums.users.count) 이게 아니라
						// 이렇게 처리해야하네..
						ForEach(viewModel.users.indices, id: \.self) { index in
							VStack {
								Button(action: {
									// 같은 인물 클릭 시 전체로
									if roleState == .all {
										viewModel.fetchAlbumUserImages(
											uploadUserId: viewModel.users[index].docId
										)
										roleState = .user
									} else {
										roleState = .all
									}
								}) {
									AsyncImage(url: URL(string: viewModel.users[index].profileImage)) { image in
										image
											.resizable()
											.aspectRatio(contentMode: .fill)
											.frame(width: 70, height: 84)
											.cornerRadius(20)
											.padding(5)
											.overlay {
												RoundedRectangle(cornerRadius: 20)
													.stroke(Color.green, lineWidth: 2)
													.padding(2)
											}
											.overlay {
												// 여우 이미지
											}
									} placeholder: {
										ProgressView()
											.frame(width: 70, height: 84)
									}
								}
								Text("\(viewModel.users[index].nickname)")
									.font(.system(size: 12))
									.fontWeight(.bold)
								Text("\(viewModel.users[index].nickname)")
									.font(.system(size: 12))
							}
						}
					}
				}
				.padding(.horizontal, 20)
				
				LazyVStack(pinnedViews: [.sectionHeaders]){
					Section {
						VStack(spacing: 4) {
							ForEach(roleState == .all ? viewModel.images.indices : viewModel.roleImage.indices, id: \.self) { index in
								if toggleOn {
									if index % 3 == 1 {
										if roleState == .all {
											FirstFeedLayout(entitys: viewModel.images[index])
										} else {
											FirstFeedLayout(entitys: viewModel.roleImage[index])
										}
									} else {
										if roleState == .all {
											SecondFeedLayout(entitys: viewModel.images[index])
										} else {
											SecondFeedLayout(entitys: viewModel.roleImage[index])
										}
									}
								} else {
									if roleState == .all {
										GalleryLayout(entitys: viewModel.images[index])
									} else {
										GalleryLayout(entitys: viewModel.roleImage[index])
									}
								}
							}
						}
						.padding(.leading, 10)
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
			viewModel.fetchAlbumImages(albumDocId: self.albumDocId)
			//			viewModel.signup()
		}
	}
}
