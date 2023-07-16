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
	@Published var albums: Album = Album(images: [], isClosed: false, users: [])
	
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
	
	
	
	//	func upload() async throws {
	//		print("???")
	//		for i in 10..<20 {
	//			try await FirebaseService.uploadAlbumImage(image: UIImage(named: "14")!, albumDocId: "T9eJMPQEGQClFHEahX6r", index: i)
	//		}
	//	}
	
//	func signup() {
//		FirebaseService.signup(user: User(docId: "", id: "id", email: "leedool3003", password: "1234",
//										  isFirstLogin: true, nickname: "azhy", profileImage: "", progressAlbum: "", finishedAlbum: [], notification: [], fcmToken: ""))
//	}
	
}
