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

struct AlbumFeedView: View {
	
	private let albumDocId: String
	
	@ObservedObject private var viewModel: AlbumViewModel
	
	@State private var layoutToggleState = true
	@State private var nowSelectedUser: User? // 현재 역할이 선택된 유저
	@State private var roleState: AlbumState = .all
	
	init(albumDocId: String, viewModel: AlbumViewModel) {
		self.albumDocId = albumDocId
		self.viewModel = viewModel
	}
	
	var body: some View {
		if viewModel.fetchState {
			ScrollView(showsIndicators: false) {
				VStack {
					ProfileCarouselView()
					LazyVStack(pinnedViews: [.sectionHeaders]){
						Section {
							ImageView()
						} header: {
							HStack {
								Toggle(isOn: self.$layoutToggleState) {
									Text((roleState == .all ? "All" : self.nowSelectedUser?.nickname)!)
								}
								.padding(.horizontal)
							}
							.frame(height: 40)
							.background(Color.white)
						}
					}
				}
			}
		} else {
			ProgressView()
				.onAppear {
					viewModel.fetchAlbumImages(albumDocId: self.albumDocId)
				}
		}
	}
}

private extension AlbumFeedView {
	
	@ViewBuilder
	func ProfileCarouselView() -> some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(alignment: .top) {
				ForEach(viewModel.users.indices, id: \.self) { index in
					VStack {
						Button(action: {
							profileRoleChanged(index: index)
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
											.stroke(Color.mainColor, lineWidth: 2)
											.padding(2)
									}
									.overlay (
										(
											roleState == .all || nowSelectedUser?.docId != viewModel.users[index].docId
											? nil : Image("chk").frame(width: 24, height: 24)
										)
										,alignment: .topTrailing
									)
									.overlay (
										Image("\(viewModel.albums.role[index])")
											.frame(width: 38, height: 38)
											.padding(.top, 80)
									)
								
							} placeholder: {
								ProgressView()
									.frame(width: 70, height: 84)
							}
						}
						Spacer().frame(height: 15)
						Text("\(viewModel.users[index].nickname)")
							.font(.system(size: 12))
							.fontWeight(.bold)
						Text("\(viewModel.users[index].nickname)")
							.font(.system(size: 12))
					}
					.overlay {
						if roleState == .user {
							if nowSelectedUser?.docId != viewModel.users[index].docId {
								Rectangle()
									.fill(Color.white)
									.cornerRadius(20)
									.opacity(0.7)
									.onTapGesture {
										profileRoleChanged(index: index)
									}
							}
						}
					}
				}
				Button {
					print("친구 추가 버튼 클릭")
				} label: {
					RoundedRectangle(cornerRadius: 20)
						.fill(Color.white)
						.frame(width: 70, height: 84)
						.overlay(
							RoundedRectangle(cornerRadius: 20)
								.stroke(Color("G5"), lineWidth: 2)
						)
						.padding(2)
						.overlay {
							Image(systemName: "plus")
								.foregroundColor(Color("G5"))
								.font(Font.system(size: 24, weight: .bold))
								.frame(width: 24, height: 24)
						}
				}
			}
		}
		.padding(.horizontal, 20)
	}
	
	func profileRoleChanged(index: Int) {
		if roleState == .all {
			viewModel.fetchAlbumUserImages(
				uploadUserId: viewModel.users[index].docId
			)
			roleState = .user
			self.nowSelectedUser = viewModel.users[index]
		} else {
			if nowSelectedUser?.docId == viewModel.users[index].docId {
				roleState = .all
				self.nowSelectedUser = nil
			} else {
				viewModel.fetchAlbumUserImages(
					uploadUserId: viewModel.users[index].docId
				)
				self.nowSelectedUser = viewModel.users[index]
			}
		}
	}
	
	@ViewBuilder
	func ImageView() -> some View {
		if roleState == .all && (viewModel.images.isEmpty || viewModel.images[0].count == 0) {
			VStack {
				Text("첫 번째 사진을 올려보세요!")
				Text("카메라로 사진을 찍어 첫 추억을 남겨보세요")
			}
			.padding(.top, UIScreen.main.bounds.height / 3.5)
		} else if roleState == .user && (viewModel.roleImage.isEmpty || viewModel.roleImage[0].count == 0) {
			Text("앨범이 비어있어요")
				.padding(.top, UIScreen.main.bounds.height / 3.5)
		} else {
			VStack(spacing: 4) {
				ForEach(roleState == .all ? viewModel.images.indices : viewModel.roleImage.indices, id: \.self) { index in
					setLayout(index: index)
				}
			}
			.padding(.leading, 10)
		}
	}
	
	@ViewBuilder
	func setLayout(index: Int) -> some View {
		if layoutToggleState {
			if index % 3 == 1 {
				if roleState == .all {
					FirstFeedLayout(viewModel: viewModel,
									entitys: viewModel.images[index],
									user: viewModel.users)
				} else {
					FirstFeedLayout(viewModel: viewModel,
									entitys: viewModel.roleImage[index],
									user: viewModel.users)
				}
			} else {
				if roleState == .all {
					SecondFeedLayout(viewModel: viewModel,
									 entitys: viewModel.images[index],
									 user: viewModel.users)
				} else {
					SecondFeedLayout(viewModel: viewModel,
									 entitys: viewModel.roleImage[index],
									 user: viewModel.users)
				}
			}
		} else {
			if roleState == .all {
				GalleryLayout(viewModel: viewModel,
							  entitys: viewModel.images[index],
							  user: viewModel.users)
			} else {
				GalleryLayout(viewModel: viewModel,
							  entitys: viewModel.roleImage[index],
							  user: viewModel.users)
			}
		}
	}
}
