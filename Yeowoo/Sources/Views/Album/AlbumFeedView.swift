//
//  AlbumView.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/14.
//

import SwiftUI

struct AlbumFeedView: View {
	
	enum AlbumState {
		case user
		case all
	}
	
	enum AlertType {
		case confirmDelete
		case confirmClosure
		case invalidAction
	}
	
	@Environment(\.dismiss) var dismiss
	
	private let albumDocId: String
	
	@ObservedObject private var mainViewModel: MainViewModel
	@ObservedObject private var viewModel: AlbumViewModel
	
	@State private var layoutToggleState = true
	@State private var nowSelectedUser: User?
	@State private var roleState: AlbumState = .all
	@State private var showingFinishAlert = false
	@State private var showingUpdateAlert = false
	@State private var showInviteAlert = false
	@State private var showingEditSheet = false
	@State private var changedAlbumTitle = ""
	@State private var showFindUserView = false
	@State private var sortToggle = true
	@State private var alertType: AlertType = .confirmDelete
	
	init(mainViewModel: MainViewModel, albumDocId: String, viewModel: AlbumViewModel) {
		self.mainViewModel = mainViewModel
		self.albumDocId = albumDocId
		self.viewModel = viewModel
	}
	
	var body: some View {
		if viewModel.fetchState {
			
			CustomNavigationBar()
			
			ScrollViewReader { proxy in
				ScrollView(showsIndicators: false) {
					VStack {
						
						ProfileCarouselView()
							.id("scroll_to_top")
						
						Spacer()
							.frame(height: 24)
						Divider()
						
						LazyVStack(pinnedViews: [.sectionHeaders]){
							Section {
								ImageView()
							} header: {
								HStack {
									HStack(spacing: 2) {
										Image(systemName: "arrow.up.arrow.down")
											.font(.system(size: 15))
											.fontWeight(.semibold)
										Text("최신순")
											.font(.system(size: 15))
											.fontWeight(.semibold)
									}
									.padding(.horizontal)
									.onTapGesture {
										sortToggle.toggle()
										viewModel.imageSort(state: sortToggle)
									}
									Toggle(isOn: self.$layoutToggleState) {}
										.onChange(of: layoutToggleState, perform: { _ in
											withAnimation(.default) {
												proxy.scrollTo("scroll_to_top", anchor: .top)
											}
										})
										.toggleStyle(CheckmarkToggleStyle())
										.padding(.horizontal)
								}
								.frame(height: 40)
								.background(Color.white)
							}
							if roleState == .all ? (!viewModel.tempVisibleImages.isEmpty)
								: (!viewModel.tempVisibleRoleImages.isEmpty) {
								ProgressView()
									.onAppear {
										roleState == .all ? viewModel.nextFetchImages() : viewModel.nextFetchRoleImages()
									}
							}
						}
					}
				}
				.scrollDisabled((viewModel.visibleImages.isEmpty || viewModel.visibleImages[0].count == 0) ? true : false)
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
					
					if viewModel.albums.isClosed {
						alertType = .confirmDelete
					} else {
						if viewModel.albums.users.first == UserDefaultsSetting.userDocId {
							alertType = .confirmClosure
						} else {
							alertType = .invalidAction
						}
					}
				} label: {
					Label(viewModel.albums.isClosed ? "여행 삭제하기" : "여행 종료하기", systemImage: "xmark.circle")
				}
			} label: {
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
							try await viewModel.updateAlbumTitle(albumDocId: viewModel.albums.id,
																 title: changedAlbumTitle)
							showingUpdateAlert = true
						}
					} label: {
						Rectangle()
							.fill(Color("B1"))
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
							dismissButton: .default(Text("확인")) {
								showingEditSheet = false
							}
						)
					}
				}
				.padding(.horizontal, 20)
				.presentationDetents([.height(250)])
			}
			.alert(isPresented: $showingFinishAlert) {
				switch alertType {
				case .confirmClosure:
					return Alert(
						title: Text("여행 종료"),
						message: Text("여행을 종료하면\n사진 및 영상 업로드가 불가능해요"),
						primaryButton: .destructive(Text("종료")) {
							Task {
								try await viewModel.closedTravel(docId: viewModel.albums.id)
								mainViewModel.finishedFetch = false
								mainViewModel.openAlbum.toggle()
								try await mainViewModel.loadAlbum()
							}
						},
						secondaryButton: .cancel(Text("취소")) { }
					)
				case .confirmDelete:
					return Alert(
						title: Text("여행 삭제"),
						message: Text("현재 계정에서만 삭제되며 복구가 불가능합니다"),
						primaryButton: .destructive(Text("삭제")) {
							Task {
								try await viewModel.removeTravel(docId: viewModel.albums.id)
								mainViewModel.finishedFetch = false
								mainViewModel.openAlbum.toggle()
								try await mainViewModel.loadAlbum()
							}
						},
						secondaryButton: .cancel(Text("취소")) { }
					)
				case .invalidAction:
					return Alert(
						title: Text("여행 종료"),
						message: Text("여행 종료는 여행을 만든 사람만 가능해요."),
						dismissButton: .cancel(Text("확인")) { }
					)
				}
				
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
							CacheAsyncImage(url: URL(string: viewModel.users[index].profileImage)!) { phase in
								switch phase {
								case .success(let image):
									image
										.resizable()
										.aspectRatio(contentMode: .fill)
										.frame(width: 70, height: 84)
										.cornerRadius(20)
										.padding(5)
										.overlay {
											RoundedRectangle(cornerRadius: 20)
												.stroke(viewModel.albums.role[index] == "normalFox"
														? Color.normalColor :
															viewModel.albums.role[index] == "eatFox"
														? Color.eatColor :
															viewModel.albums.role[index] == "activityFox"
														? Color.activityColor :
															viewModel.albums.role[index] == "captaionFox"
														? Color.captaionColor :
															viewModel.albums.role[index] == "paparazziFox"
														? Color.paparazziColor : Color.sceneColor, lineWidth: 2)
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
									
								default:
									ProgressView()
										.frame(width: 70, height: 84)
								}
							}
						}
						Spacer().frame(height: 24)
						Text("\(viewModel.users[index].nickname)")
							.font(.system(size: 12))
							.fontWeight(.bold)
						Text("\(viewModel.users[index].id)")
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
					if viewModel.albums.isClosed {
						showInviteAlert = true
					} else {
						showFindUserView = true
					}
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
				.alert(isPresented: $showInviteAlert) {
					Alert(
						title: Text("친구 초대"),
						message: Text("여행이 종료되면 친구를 초대를 할 수 없어요."),
						dismissButton: .default(Text("확인")) { }
					)
				}
				.background (
					NavigationLink("", destination:
									InviteFriendView(newAlbum: self.viewModel.albums)
						.navigationBarBackButtonHidden()
								   , isActive: $showFindUserView)
				)
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
		if roleState == .all && (viewModel.visibleImages.isEmpty || viewModel.visibleImages[0].count == 0) {
			VStack(spacing: 10) {
				Text("첫 번째 사진을 올려보세요!")
					.font(.system(size: 20))
					.fontWeight(.semibold)
				Text("카메라로 사진을 찍어 첫 추억을 남겨보세요")
					.font(.system(size: 14))
					.foregroundColor(Color("G3"))
			}
			.padding(.top, UIScreen.main.bounds.width / 2)
		} else if roleState == .user && (viewModel.roleImage.isEmpty || viewModel.roleImage[0].count == 0) {
			Text("앨범이 비어있어요")
				.font(.system(size: 20))
				.foregroundColor(Color("G3"))
				.padding(.top, UIScreen.main.bounds.width / 2)
		} else {
			VStack(spacing: layoutToggleState ? 0 : 2) {
				ForEach(roleState == .all ? viewModel.visibleImages.indices
						: viewModel.visibleRoleImages.indices, id: \.self) { index in
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
							  mainViewModel: mainViewModel,
							  entitys: viewModel.visibleImages[index],
							  user: viewModel.users,
							  entityIndex: index)
			} else {
				GalleryLayout(viewModel: viewModel,
							  mainViewModel: mainViewModel,
							  entitys: viewModel.visibleRoleImages[index],
							  user: viewModel.users,
							  entityIndex: index)
			}
		} else {
			if index % 3 == 1 {
				if roleState == .all {
					FirstFeedLayout(mainViewModel: mainViewModel,
									entityIndex: index,
									entitys: viewModel.visibleImages[index],
									user: viewModel.users,
									viewModel: viewModel)
				} else {
					FirstFeedLayout(mainViewModel: mainViewModel,
									entityIndex: index,
									entitys: viewModel.visibleRoleImages[index],
									user: viewModel.users,
									viewModel: viewModel)
				}
			} else {
				if roleState == .all {
					SecondFeedLayout(mainViewModel: mainViewModel,
									 entityIndex: index,
									 entitys: viewModel.visibleImages[index],
									 user: viewModel.users,
									 viewModel: viewModel)
				} else {
					SecondFeedLayout(mainViewModel: mainViewModel,
									 entityIndex: index,
									 entitys: viewModel.visibleRoleImages[index],
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
				.foregroundColor(configuration.isOn ? Color("B1") : Color("G5"))
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
