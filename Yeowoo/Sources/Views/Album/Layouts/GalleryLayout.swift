//
//  AlbumGalleryView.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/14.
//

import SwiftUI

struct GalleryLayout: View {
	
	@State private var detailIndex: Int = 0
	@State private var isActive: Bool = false
	
	var entitys: [ImagesEntity]
	var user: [User]
	
	var body: some View {
		ForEach(entitys.indices, id: \.self) { index in
			NavigationLink(destination:
							AlbumDetailView(entitys: entitys[detailIndex],
											user: self.user.first(where: {$0.docId == entitys[detailIndex].uploadUser}) ?? User(docId: "", id: "", email: "", password: "", isFirstLogin: false, nickname: "azhy", profileImage: "https://firebasestorage.googleapis.com/v0/b/yeowoo-186cd.appspot.com/o/album1%2F1.jpeg?alt=media&token=eeea845a-b7e0-4d77-a2d0-c3b30ca439e9", progressAlbum: "", finishedAlbum: [], notification: [], fcmToken: ""),
											testBool: entitys[detailIndex].likeUsers.contains(UserDefaultsSetting.userDocId),
											testCount: entitys[detailIndex].likeUsers.count)
						   ,isActive: $isActive
			){
				Button {
					detailIndex = index
					isActive = true
				} label: {
					AsyncImage(url: URL(string: entitys[index].url)) { image in
						image
							.resizable()
							.aspectRatio(contentMode: .fill)
							.frame(width: UIScreen.main.bounds.width, height: 390)
							.cornerRadius(4)
							.overlay {
								HStack(alignment: .bottom) {
									Divider().opacity(0)
									Text("\(entitys[index].comment)")
										.font(.system(size: 14))
										.foregroundColor(Color.white)
									Spacer()
									VStack {
										Circle()
											.fill(Color.white)
											.opacity(0.25)
											.frame(width: 48, height: 48)
											.overlay {
												Image(systemName: "heart.fill")
													.foregroundColor(Color.white)
											}
										Rectangle()
											.fill(Color.white)
											.opacity(0.25)
											.frame(width: 48, height: 24)
											.cornerRadius(100)
											.overlay {
												Text("\(entitys[index].likeUsers.count)")
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
							.frame(width: UIScreen.main.bounds.width, height: 390)
					}
				}
				.overlay(
					Image(systemName: entitys[index].likeUsers.contains(UserDefaultsSetting.userDocId) ? "heart.fill" : "")
						.padding(6),
					alignment: .topTrailing
				)
			}
		}
	}
}
