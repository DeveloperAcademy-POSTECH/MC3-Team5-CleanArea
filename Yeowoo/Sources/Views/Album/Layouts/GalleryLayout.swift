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
	
	@ObservedObject var viewModel: AlbumViewModel
	
	var entitys: [ImagesEntity]
	var user: [User]
	
	var body: some View {
		ForEach(entitys.indices, id: \.self) { index in
			NavigationLink(destination:
							AlbumDetailView(entitys: entitys[detailIndex],
											user: self.user.first(where: {$0.docId == entitys[detailIndex].uploadUser}) ?? User(),
											tempLikeState: entitys[detailIndex].likeUsers.contains(UserDefaultsSetting.userDocId),
											tempLikeCount: entitys[detailIndex].likeUsers.count,
											viewModel: self.viewModel)
						   ,isActive: $isActive
			){
				VStack(spacing: 0) {
					Button {
						detailIndex = index
						isActive = true
					} label: {
						AsyncImage(url: URL(string: entitys[index].url)) { image in
							image
								.resizable()
								.aspectRatio(contentMode: .fill)
								.frame(width: UIScreen.main.bounds.width, height: 390)
								.cornerRadius(0)
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
														.foregroundColor(entitys[index].likeUsers.contains(UserDefaultsSetting.userDocId)
																		 ? Color.red : Color.white)
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
					Spacer()
						.frame(height: 2)
				}
			}
		}
		.navigationBarTitle("")
		.navigationBarHidden(true)
	}
}
