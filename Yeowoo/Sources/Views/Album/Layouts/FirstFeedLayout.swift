//
//  FirstLayout.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/14.
//

import SwiftUI
import UIKit

var width = UIScreen.main.bounds.width - 30

struct FirstFeedLayout: View {
	
	@State private var detailIndex: Int = 0
	@State private var isActive: Bool = false
	
	@StateObject var viewModel = AlbumViewModel()
	
	var entitys: [ImagesEntity]
	var user: [User]
	
	var body: some View {
		NavigationLink (
			destination:
				AlbumDetailView(entitys: entitys[detailIndex],
								user: self.user.first(where: {$0.docId == entitys[detailIndex].uploadUser}) ?? User(docId: "", id: "", email: "", password: "", isFirstLogin: false, nickname: "azhy", profileImage: "https://firebasestorage.googleapis.com/v0/b/yeowoo-186cd.appspot.com/o/album1%2F1.jpeg?alt=media&token=eeea845a-b7e0-4d77-a2d0-c3b30ca439e9", progressAlbum: "", finishedAlbum: [], notification: [], fcmToken: ""),
								testBool: entitys[detailIndex].likeUsers.contains(UserDefaultsSetting.userDocId),
								testCount: entitys[detailIndex].likeUsers.count)
			,isActive: $isActive
		) {
			HStack(spacing: 4) {
				Button {
					print("???")
					detailIndex = 0
					isActive = true
				} label: {
					AsyncImage(url: URL(string: entitys[0].url)) { image in
						image
							.resizable()
							.aspectRatio(contentMode: .fill)
							.frame(width: width / 3, height: 250)
							.cornerRadius(4)
					} placeholder: {
						ProgressView()
							.frame(width: width / 3, height: 250)
					}
				}
				.overlay(
					Image(systemName: entitys[0].likeUsers.contains(UserDefaultsSetting.userDocId) ? "heart.fill" : "")
						.padding(6),
					alignment: .topTrailing
				)
				VStack(spacing: 4) {
					if entitys.count >= 2 {
						Button {
							detailIndex = 1
							isActive = true
						} label: {
							AsyncImage(url: URL(string: entitys[1].url)) { image in
								image
									.resizable()
									.aspectRatio(contentMode: .fill)
									.frame(width: width / 3, height: 123)
									.cornerRadius(4)
							} placeholder: {
								ProgressView()
									.frame(width: width / 3, height: 123)
							}
						}
						.overlay(
							Image(systemName: entitys[1].likeUsers.contains(UserDefaultsSetting.userDocId) ? "heart.fill" : "")
								.padding(6),
							alignment: .topTrailing
						)
					}
					if entitys.count >= 3 {
						Button {
							detailIndex = 2
							isActive = true
						} label: {
							AsyncImage(url: URL(string: entitys[2].url)) { image in
								image
									.resizable()
									.aspectRatio(contentMode: .fill)
									.frame(width: width / 3, height: 123)
									.cornerRadius(4)
							} placeholder: {
								ProgressView()
									.frame(width: width / 3, height: 123)
							}
						}
						.overlay(
							Image(systemName: entitys[2].likeUsers.contains(UserDefaultsSetting.userDocId) ? "heart.fill" : "")
								.padding(6),
							alignment: .topTrailing
						)
					}
				}
				.frame(maxHeight: .infinity, alignment: .top)
				
				VStack(spacing: 4) {
					if entitys.count >= 4 {
						Button {
							detailIndex = 3
							isActive = true
						} label: {
							AsyncImage(url: URL(string: entitys[3].url)) { image in
								image
									.resizable()
									.aspectRatio(contentMode: .fill)
									.frame(width: width / 3, height: 123)
									.cornerRadius(4)
							} placeholder: {
								ProgressView()
									.frame(width: width / 3, height: 123)
							}
						}
						.overlay(
							Image(systemName: entitys[3].likeUsers.contains(UserDefaultsSetting.userDocId) ? "heart.fill" : "")
								.padding(6),
							alignment: .topTrailing
						)
					}
					if entitys.count >= 5 {
						Button {
							detailIndex = 4
							isActive = true
						} label: {
							AsyncImage(url: URL(string: entitys[4].url)) { image in
								image
									.resizable()
									.aspectRatio(contentMode: .fill)
									.frame(width: width / 3, height: 123)
									.cornerRadius(4)
							} placeholder: {
								ProgressView()
									.frame(width: width / 3, height: 123)
							}
						}
						.overlay(
							Image(systemName: entitys[4].likeUsers.contains(UserDefaultsSetting.userDocId) ? "heart.fill" : "")
								.padding(6),
							alignment: .topTrailing
						)
					}
				}
				.frame(maxHeight: .infinity, alignment: .top)
			}
			.frame(maxWidth: .infinity, alignment: .leading)
		}
	}
}
