//
//  AlbumDetailView.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/16.
//

import SwiftUI

struct AlbumDetailView: View {
	
	var entitys: ImagesEntity
	var user: User
	
	@State var testBool: Bool
	@State var testCount: Int
	
	@ObservedObject var viewModel = AlbumViewModel()
	
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
											print("action")
											Task {
												try await viewModel.actionLike(toggleChk: testBool, fileName: entitys.fileName)
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
			entitys.uploadTime.formatAsDateString()
		)
		.navigationBarTitleDisplayMode(.inline)
		.navigationBarItems(
			trailing:
				Menu {
					Button {
						print("사진 저장")
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
					} label: {
						Label("사진 저장", systemImage: "square.and.arrow.down")
					}
					Button {
						print("대표 이미지 설정")
					} label: {
						Label("대표 이미지 설정", systemImage: "star")
					}
					Button(role: .destructive) {
						print("삭제")
					} label: {
						Label("삭제", systemImage: "trash")
					}
				}
			label: {
				Image(systemName: "ellipsis")
			}
		)
	}
}
