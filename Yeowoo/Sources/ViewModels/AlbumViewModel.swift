//
//  AlbumViewModel.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/14.
//

import Combine
import Foundation
import UIKit

final class AlbumViewModel: ObservableObject {
	
	@Published var fetchState = false
	@Published var roleImage: [[ImagesEntity]] = []
	@Published var users: [User] = []
	@Published var images: [[ImagesEntity]] = []
	@Published var albums: Album = Album(albumTitle: "", albumCoverImage: "", startTime: "",
										 finishTime: "", images: [], isClosed: false, users: [])
	
	private var cancellables = Set<AnyCancellable>()
	
	@MainActor
	func fetchAlbumImages(albumDocId: String) {
		FirebaseService.fetchAlbumImages(albumDocId: albumDocId)
			.sink { completion in
				switch completion {
				case .failure(let error):
					print(error.localizedDescription)
				case .finished:
					return
				}
			} receiveValue: { images in
				self.albums = images
				var urls: [ImagesEntity] = []
				self.fetchUser(userDocIds: images.users)
				images.images.forEach { url in
					urls.append(url)
					if urls.count == 5 {
						self.images.append(urls)
						urls.removeAll()
					}
				}
				self.images.append(urls)
				self.fetchState = true
			}
			.store(in: &cancellables)
	}
	
	@MainActor
	func fetchUser(userDocIds: [String]) {
		FirebaseService.fetchUser(userDocIds: userDocIds)
			.sink { completion in
				switch completion {
				case .failure(let error):
					print(error.localizedDescription)
				case .finished:
					return
				}
			} receiveValue: { user in
				self.users = user
			}
			.store(in: &cancellables)
	}
	
	// 역할 클릭했을 때
	@MainActor
	func fetchAlbumUserImages(uploadUserId: String) {
		roleImage.removeAll()
		var urls: [ImagesEntity] = []
		images.forEach { imageEntitys in
			imageEntitys.forEach { imageEntity in
				if imageEntity.uploadUser == uploadUserId && imageEntity.roleCheck {
					urls.append(imageEntity)
					if urls.count == 5 {
						roleImage.append(urls)
						urls.removeAll()
					}
				}
			}
		}
		if !urls.isEmpty {
			roleImage.append(urls)
		}
	}
	
	// 좋아요 눌렀을 때
	func actionLike(toggleChk: Bool, fileName: String) async throws {
		toggleChk ? try await FirebaseService.removeUserFromLikeUsers(albumDocId: "T9eJMPQEGQClFHEahX6r", paramFileName: "123") : try await FirebaseService.updateLikeUsers(albumDocId: "T9eJMPQEGQClFHEahX6r", paramFileName: "123")
	}
}
