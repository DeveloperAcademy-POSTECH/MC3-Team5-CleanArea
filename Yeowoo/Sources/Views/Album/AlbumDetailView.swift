//
//  AlbumDetailView.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/16.
//

import SwiftUI

struct AlbumDetailView: View {
	
	enum AlertType: Identifiable {
		case save, edit, remove, blockRemove
		var id: Int {
			switch self {
			case .save: return 0
			case .edit: return 1
			case .remove: return 2
			case .blockRemove: return 3
			}
		}
	}
	
	@Environment(\.dismiss) var dismiss
	
	@State private var entitys: ImagesEntity
	private var user: User
	private var entityIndex: Int
	
    @ObservedObject private var mainViewModel: MainViewModel
	@ObservedObject private var viewModel: AlbumViewModel
	
	@State private var tempLikeState: Bool
	@State private var tempLikeCount: Int
	@State private var alertType: AlertType? = nil
	@State private var showRemoveAlert = false
	
    init(mainViewModel: MainViewModel, entityIndex: Int, entitys: ImagesEntity, user: User,
		 tempLikeState: Bool, tempLikeCount: Int, viewModel: AlbumViewModel) {
        self.mainViewModel = mainViewModel
		self.entityIndex = entityIndex
		self._entitys = State(initialValue: entitys)
		self.user = user
		self._tempLikeState = State(initialValue: tempLikeState)
		self._tempLikeCount = State(initialValue: tempLikeCount)
		self.viewModel = viewModel
	}
	
	var body: some View {
		VStack(alignment: .leading) {
			
			CustomNavigationBar()
			
			UploadUserProfileView()
			
			ImageView()
			
			CommentView()
		}
		.navigationBarTitle("")
		.navigationBarHidden(true)
		.onAppear {
			viewModel.likeChk = false
		}
		.onDisappear {
			if viewModel.likeChk {
				Task {
					if tempLikeState {
						entitys.likeUsers.append(UserDefaultsSetting.userDocId)
					} else {
						if let index = entitys.likeUsers.firstIndex(of: UserDefaultsSetting.userDocId) {
							entitys.likeUsers.remove(at: index)
						}
					}
					viewModel.afterLikeFetch(entityIndex: entityIndex, entity: entitys)
				}
			}
		}
	}
}

private extension AlbumDetailView {
	
	@ViewBuilder
	func CustomNavigationBar() -> some View {
		HStack {
			Image(systemName: "chevron.backward")
				.foregroundColor(Color("G4"))
				.onTapGesture {
					dismiss()
				}
			Spacer()
			Text(getFormattedDateString(entitys.uploadTime))
				.font(.system(size: 18))
				.fontWeight(.semibold)
			Spacer()
			Menu {
				Button {
					alertType = .save
				} label: {
					Label("사진 저장", systemImage: "square.and.arrow.down")
				}
				Button {
					alertType = .edit
				} label: {
					Label("대표 이미지 설정", systemImage: "star")
				}
				Button(role: .destructive) {
					alertType = .remove
				} label: {
					Label("삭제", systemImage: "trash")
				}
			} label: {
				Image(systemName: "ellipsis")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.foregroundColor(Color("G4"))
					.rotationEffect(Angle(degrees: 90))
					.frame(width: UIScreen.getHeight(22), height: UIScreen.getWidth(42))
			}
			.alert(item: $alertType) { alertType in
				switch alertType {
				case .save:
					return Alert(
						title: Text("사진 저장"),
						message: Text("갤러리에 사진을 저장했어요"),
						dismissButton: .default(Text("확인")) {
							guard let imageURL = URL(string: entitys.url) else {
								print("Invalid image URL")
								return
							}
							URLSession.shared.dataTask(with: imageURL) { data, response, error in
								if let error = error {
									print("Error downloading image: \(error.localizedDescription)")
									return
								}
								if let data = data, let image = UIImage(data: data) {
									UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
								}
							}.resume()
						}
					)
				case .edit:
					return Alert(
						title: Text("대표 이미지 설정"),
						message: Text("앨범 대표 이미지를 변경할까요?"),
						primaryButton: .destructive(Text("변경")) {
							Task {
								try await viewModel.updateAlbumCoverImage(albumDocId: viewModel.albums.id,
																		  url: entitys.url)
                                mainViewModel.finishedFetch = false
                                mainViewModel.openAlbum.toggle()
                                try await mainViewModel.loadAlbum()
							}
							dismiss()
						},
						secondaryButton: .cancel(Text("취소")) {}
					)
				case .remove:
					return Alert(
						title: Text("사진 삭제"),
						message: Text("사진을 삭제할까요?"),
						primaryButton: .destructive(Text("삭제")) {
							print("entitys.fileName \(entitys.fileName)")
							dismiss()
							if entitys.uploadUser == UserDefaultsSetting.userDocId {
								Task {
									try await viewModel.deleteAlbumImage(albumDocId: viewModel.albums.id,
																		 fileName: entitys.fileName)
								}
							} else {
								self.alertType = .blockRemove
							}
						},
						secondaryButton: .cancel(Text("취소")) {}
					)
				case .blockRemove:
					return Alert(
						title: Text("사진 삭제"),
						message: Text("본인이 올린 사진만 삭제가 가능해요."),
						dismissButton: .default(Text("확인")) { }
					)
				}
			}
		}
		.frame(height: 48)
		.padding(.horizontal, 20)
	}
	
	@ViewBuilder
	func UploadUserProfileView() -> some View {
		HStack() {
			AsyncImage(url: URL(string: user.profileImage)) { image in
				image
					.resizable()
					.frame(width: 32, height: 32)
					.clipShape(Circle())
			} placeholder: {
				ProgressView()
					.frame(width: 32, height: 32)
			}
			Text(user.nickname)
				.font(.system(size: 12))
				.fontWeight(.semibold)
			Spacer()
		}
		.padding(.horizontal, 20)
	}
	
	@ViewBuilder
	func ImageView() -> some View {
		AsyncImage(url: URL(string: entitys.url)) { image in
			image
				.resizable()
				.frame(height: 500)
				.cornerRadius(20)
				.overlay {
					HStack(alignment: .bottom) {
						Divider().opacity(0)
						Spacer()
						VStack {
							Circle()
								.fill(Color.white)
								.opacity(0.25)
								.frame(width: 48, height: 48)
								.overlay {
									Button {
										Task {
											try await viewModel.actionLike(toggleChk: tempLikeState,
																		   albumDocId: viewModel.albums.id,
																		   fileName: entitys.fileName)
											tempLikeCount = tempLikeState ? tempLikeCount - 1 : tempLikeCount + 1
											tempLikeState.toggle()
										}
									} label: {
										Image(systemName: "heart.fill")
											.foregroundColor(tempLikeState ? Color.red : Color.white)
									}
								}
							Rectangle()
								.fill(Color.white)
								.opacity(0.25)
								.frame(width: 48, height: 24)
								.cornerRadius(100)
								.overlay {
									Text("\(tempLikeCount)")
										.font(.system(size: 16, weight: .medium))
										.foregroundColor(Color.white)
								}
						}
					}
					.padding(.horizontal)
					.padding(.bottom, 20)
				}
		} placeholder: {
			ProgressView()
				.frame(width: UIScreen.main.bounds.width, height: 500)
		}
		.padding(.horizontal, 4)
	}
	
	@ViewBuilder
	func CommentView() -> some View {
		Spacer()
			.frame(height: 16)
		Text(entitys.comment)
			.font(.system(size: 14))
			.foregroundColor(Color.black)
			.padding(.horizontal, 20)
		Spacer()
	}
	
	func getFormattedDateString(_ dateString: String) -> String {
		let startIndex = dateString.startIndex
		let endIndex = dateString.index(startIndex, offsetBy: 10)
		return String(dateString[startIndex..<endIndex])
	}
}
