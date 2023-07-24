//
//  AlbumDetailView.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/16.
//

import SwiftUI

struct AlbumDetailView: View {
	
	@Environment(\.dismiss) var dismiss
	
	enum AlertType: Identifiable {
		case save, edit, remove
		
		var id: Int {
			switch self {
			case .save:
				return 0
			case .edit:
				return 1
			case .remove:
				return 2
			}
		}
	}
	
	var entitys: ImagesEntity
	var user: User
	
	@State var testBool: Bool
	@State var testCount: Int
	
	@State private var alertType: AlertType? = nil
	
	@ObservedObject var viewModel: AlbumViewModel
	
	var body: some View {
		VStack(alignment: .leading) {
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
				Spacer()
			}
			.padding(.horizontal, 20)
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
												try await viewModel.actionLike(toggleChk: testBool,
																			   albumDocId: viewModel.albums.id,
																			   fileName: entitys.fileName)
												testCount = testBool ? testCount - 1 : testCount + 1
												testBool.toggle()
											}
										} label: {
											Image(systemName: "heart.fill")
												.foregroundColor(testBool ? Color.red : Color.white)
										}
									}
								Rectangle()
									.fill(Color.white)
									.opacity(0.25)
									.frame(width: 48, height: 24)
									.cornerRadius(100)
									.overlay {
										Text("\(testCount)")
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
			Text(entitys.comment)
				.font(.system(size: 14))
				.foregroundColor(Color.black)
				.padding(.horizontal, 20)
			Spacer()
		}
		.navigationTitle(
			entitys.uploadTime
		)
		.navigationBarTitleDisplayMode(.inline)
		.navigationBarItems(
			trailing:
				Menu {
					Button {
						print("사진 저장")
						alertType = .save
					} label: {
						Label("사진 저장", systemImage: "square.and.arrow.down")
					}
					
					Button {
						print("대표 이미지 설정")
						alertType = .edit
					} label: {
						Label("대표 이미지 설정", systemImage: "star")
					}
					
					Button(role: .destructive) {
						print("삭제")
						alertType = .remove
					} label: {
						Label("삭제", systemImage: "trash")
					}
				}
			label: {
				Image(systemName: "ellipsis")
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
								Task {
									try await viewModel.deleteAlbumImage(albumDocId: viewModel.albums.id,
																		 fileName: entitys.fileName)
								}
								dismiss()
							},
							secondaryButton: .cancel(Text("취소")) {}
						)
					}
				}
		)
		.onDisappear {
			if viewModel.likeChk {
				Task {
					viewModel.fetchAlbumImages(albumDocId: viewModel.albums.id)
				}
			}
		}
	}
}
