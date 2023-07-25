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
	
	@Environment(\.dismiss) var dismiss
	
	private let albumDocId: String
	
	@ObservedObject private var viewModel: AlbumViewModel
	
	@State private var layoutToggleState = true
	@State private var nowSelectedUser: User? // 현재 역할이 선택된 유저
	@State private var roleState: AlbumState = .all
	@State private var showingFinishAlert = false
	@State private var showingUpdateAlert = false
	@State private var showingEditSheet = false
	@State private var changedAlbumTitle = ""
	
	// sort 임시 토글
	@State private var testSortToggle = true
	
	init(albumDocId: String, viewModel: AlbumViewModel) {
		self.albumDocId = albumDocId
		self.viewModel = viewModel
	}
	
	var body: some View {
		if viewModel.fetchState {
			
			CustomNavigationBar()
			
			ScrollView(showsIndicators: false) {
				VStack {
					
					ProfileCarouselView()
					
					Spacer()
						.frame(height: 24)
					Divider()
					
					// sort 임시 토글
					Toggle(isOn: self.$testSortToggle) { }
						.onChange(of: testSortToggle) { newValue in
							viewModel.imageSort(state: newValue)
						}
					
					LazyVStack(pinnedViews: [.sectionHeaders]){
						Section {
							ImageView()
						} header: {
							HStack {
								Toggle(isOn: self.$layoutToggleState) {
									Text((roleState == .all ? "All" : self.nowSelectedUser?.nickname)!)
								}
								.toggleStyle(CheckmarkToggleStyle())
								.padding(.horizontal)
							}
							.frame(height: 40)
							.background(Color.white)
						}
					}
				}
			}
			.navigationBarTitle("")
			.navigationBarHidden(true)
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
	func CustomNavigationBar() -> some View {
		HStack {
			Image(systemName: "chevron.backward")
				.foregroundColor(Color("G4"))
				.onTapGesture {
					dismiss()
				}
			Spacer()
			Text("\(viewModel.albumTitle)")
				.font(.system(size: 18))
				.fontWeight(.semibold)
			Spacer()
			Menu {
				Button {
					showingEditSheet = true
				} label: {
					Label("앨범 제목 수정하기", systemImage: "pencil")
				}
				Button(role: .destructive) {
					showingFinishAlert = true
				} label: {
					Label("여행 종료하기", systemImage: "xmark.circle")
				}
			}
		label: {
			Image(systemName: "ellipsis")
				.foregroundColor(Color("G4"))
				.rotationEffect(Angle(degrees: 90))
		}
		.sheet(isPresented: $showingEditSheet) {
			VStack(spacing: 24) {
				Text("앨범 제목 수정하기")
					.font(.system(size: 18))
					.fontWeight(.bold)
				TextField("20자 이내로 입력해주세요", text: $changedAlbumTitle)
					.font(.system(size: 16))
					.padding()
					.background(Color(uiColor: .secondarySystemBackground))
					.cornerRadius(10)
					.onAppear {
						UITextField.appearance().clearButtonMode = .whileEditing
					}
				Button {
					Task {
						try await viewModel.updateAlbumTitle(albumDocId: "T9eJMPQEGQClFHEahX6r",
															 title: changedAlbumTitle)
						showingUpdateAlert = true
					}
				} label: {
					Rectangle()
						.fill(Color.mainColor)
						.frame(height: 54)
						.cornerRadius(10)
						.overlay {
							Text("완료")
								.font(.system(size: 18))
								.fontWeight(.bold)
								.foregroundColor(Color.white)
						}
				}
				.alert(isPresented: $showingUpdateAlert) {
					Alert(
						title: Text("제목 수정"),
						message: Text("앨범 제목을 수정했어요."),
						dismissButton: .default(Text("확인")) { }
					)
				}
				
			}
			.padding(.horizontal, 20)
			.presentationDetents([.height(250)])
		}
		.alert(isPresented: $showingFinishAlert) {
			Alert(
				title: Text(viewModel.albums.isClosed ? "여행 삭제" : "여행 종료"),
				message: Text(viewModel.albums.isClosed ? "현재 계정에서만 삭제되며 복구가 불가능합니다" :
								"여행을 종료하면\n사진 및 영상 업로드가 불가능해요"),
				primaryButton: .destructive(Text(viewModel.albums.isClosed ? "삭제" : "종료")) {
					Task {
						viewModel.albums.isClosed ? try await viewModel.removeTravel(docId: "") :
						try await viewModel.closedTravel(docId: "")
					}
				},
				secondaryButton: .cancel(Text("취소")) { }
			)
		}
		}
		.frame(height: 48)
		.padding(.horizontal, 20)
	}
	
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
			VStack(spacing: layoutToggleState ? 0 : 2) {
				ForEach(roleState == .all ? viewModel.images.indices : viewModel.roleImage.indices, id: \.self) { index in
					setLayout(index: index)
				}
			}
		}
	}
	
	@ViewBuilder
	func setLayout(index: Int) -> some View {
		if layoutToggleState {
			if roleState == .all {
				GalleryLayout(viewModel: viewModel,
							  entitys: viewModel.images[index],
							  user: viewModel.users)
			} else {
				GalleryLayout(viewModel: viewModel,
							  entitys: viewModel.roleImage[index],
							  user: viewModel.users)
			}
		} else {
			if index % 3 == 1 {
				if roleState == .all {
					FirstFeedLayout(entitys: viewModel.images[index],
									user: viewModel.users,
									viewModel: viewModel)
				} else {
					FirstFeedLayout(entitys: viewModel.roleImage[index],
									user: viewModel.users,
									viewModel: viewModel)
				}
			} else {
				if roleState == .all {
					SecondFeedLayout(entitys: viewModel.images[index],
									 user: viewModel.users,
									 viewModel: viewModel)
				} else {
					SecondFeedLayout(entitys: viewModel.roleImage[index],
									 user: viewModel.users,
									 viewModel: viewModel)
				}
			}
		}
	}
}

struct CheckmarkToggleStyle: ToggleStyle {
	func makeBody(configuration: Configuration) -> some View {
		HStack {
			configuration.label
			Spacer()
			Rectangle()
				.foregroundColor(configuration.isOn ? Color.mainColor : Color("G5"))
				.frame(width: 60, height: 32, alignment: .center)
				.overlay(
					Circle()
						.foregroundColor(.white)
						.padding(.all, 4)
						.overlay(
							Image(systemName: configuration.isOn ? "rectangle.grid.1x2" : "rectangle.grid.2x2")
								.resizable()
								.aspectRatio(contentMode: .fit)
								.frame(width: 16, height: 16, alignment: .center)
						)
						.offset(x: configuration.isOn ? 14 : -14, y: 0)
						.animation(Animation.linear(duration: 0.2), value: UUID())
				).cornerRadius(20)
				.onTapGesture { configuration.isOn.toggle() }
		}
	}
}
