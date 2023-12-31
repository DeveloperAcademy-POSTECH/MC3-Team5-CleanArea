//
//  ThirdLayout.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/14.
//

import SwiftUI

struct SecondFeedLayout: View {
	
	private var entitys: [ImagesEntity]
	private var user: [User]
	private var entityIndex: Int
	
	@ObservedObject private var mainViewModel: MainViewModel
	@ObservedObject private var viewModel: AlbumViewModel
	
	@State private var detailIndex: Int = 0
	@State private var isActive: Bool = false
	
	init(mainViewModel: MainViewModel,
		 entityIndex: Int,
		 entitys: [ImagesEntity],
		 user: [User],
		 viewModel: AlbumViewModel) {
		self.mainViewModel = mainViewModel
		self.entityIndex = entityIndex
		self.entitys = entitys
		self.user = user
		self.viewModel = viewModel
	}
	
	var body: some View {
		NavigationLink (
			destination:
				AlbumDetailView(mainViewModel: mainViewModel,
								entityIndex: entityIndex,
								entitys: entitys[detailIndex],
								user: self.user.first(where: {$0.docId == entitys[detailIndex].uploadUser}) ?? User(),
								tempLikeState: entitys[detailIndex].likeUsers.contains(UserDefaultsSetting.userDocId),
								tempLikeCount: entitys[detailIndex].likeUsers.count,
								viewModel: self.viewModel)
			,isActive: $isActive
		) {
			HStack(spacing: feedSpacing) {
				VStack(spacing: feedSpacing){
					Button {
						detailIndex = 0
						isActive = true
					} label: {
						CacheAsyncImage(url: URL(string: entitys[0].url)!) { phase in
							switch phase {
							case .success(let image):
								image
									.resizable()
									.aspectRatio(contentMode: .fill)
									.frame(width: width / 3, height: 123)
									.cornerRadius(0)
							default:
								ProgressView()
									.frame(width: width / 3, height: 123)
							}
						}
					}
					.overlay(
						Image(systemName: entitys[0].likeUsers.contains(UserDefaultsSetting.userDocId)
							  ? "heart.fill" : "")
						.foregroundColor(.white)
						.padding(6),
						alignment: .topTrailing
					)
					if entitys.count >= 2 {
						Button {
							detailIndex = 1
							isActive = true
						} label: {
							CacheAsyncImage(url: URL(string: entitys[1].url)!) { phase in
								switch phase {
								case .success(let image):
									image
										.resizable()
										.aspectRatio(contentMode: .fill)
										.frame(width: width / 3, height: 123)
										.cornerRadius(0)
								default:
									ProgressView()
										.frame(width: width / 3, height: 123)
								}
							}
						}
						.overlay(
							Image(systemName: entitys[1].likeUsers.contains(UserDefaultsSetting.userDocId)
								  ? "heart.fill" : "")
							.foregroundColor(.white)
							.padding(6),
							alignment: .topTrailing
						)
					}
				}
				.frame(maxHeight: .infinity, alignment: .top)
				
				VStack(spacing: feedSpacing) {
					if entitys.count >= 3 {
						Button {
							detailIndex = 2
							isActive = true
						} label: {
							CacheAsyncImage(url: URL(string: entitys[2].url)!) { phase in
								switch phase {
								case .success(let image):
									image
										.resizable()
										.aspectRatio(contentMode: .fill)
										.frame(width: width / 3, height: 123)
										.cornerRadius(0)
								default:
									ProgressView()
										.frame(width: width / 3, height: 123)
								}
							}
						}
						.overlay(
							Image(systemName: entitys[2].likeUsers.contains(UserDefaultsSetting.userDocId)
								  ? "heart.fill" : "")
							.foregroundColor(.white)
							.padding(6),
							alignment: .topTrailing
						)
					}
					if entitys.count >= 4 {
						Button {
							detailIndex = 3
							isActive = true
						} label: {
							CacheAsyncImage(url: URL(string: entitys[3].url)!) { phase in
								switch phase {
								case .success(let image):
									image
										.resizable()
										.aspectRatio(contentMode: .fill)
										.frame(width: width / 3, height: 123)
										.cornerRadius(0)
								default:
									ProgressView()
										.frame(width: width / 3, height: 123)
								}
							}
						}
						.overlay(
							Image(systemName: entitys[3].likeUsers.contains(UserDefaultsSetting.userDocId)
								  ? "heart.fill" : "")
							.foregroundColor(.white)
							.padding(6),
							alignment: .topTrailing
						)
					}
				}
				.frame(maxHeight: .infinity, alignment: .top)
				if entitys.count >= 5 {
					Button {
						detailIndex = 4
						isActive = true
					} label: {
						CacheAsyncImage(url: URL(string: entitys[4].url)!) { phase in
							switch phase {
							case .success(let image):
								image
									.resizable()
									.aspectRatio(contentMode: .fill)
									.frame(width: width / 3, height: 250)
									.cornerRadius(0)
							default:
								ProgressView()
									.frame(width: width / 3, height: 250)
							}
						}
					}
					.overlay(
						Image(systemName: entitys[4].likeUsers.contains(UserDefaultsSetting.userDocId)
							  ? "heart.fill" : "")
						.foregroundColor(.white)
						.padding(6),
						alignment: .topTrailing
					)
				}
			}
			.frame(maxWidth: .infinity, alignment: .leading)
		}
	}
}
