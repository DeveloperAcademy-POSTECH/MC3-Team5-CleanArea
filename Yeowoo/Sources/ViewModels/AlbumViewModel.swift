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
	
	@Published var albumTitle = ""
	@Published var fetchState = false
	@Published var roleImage: [[ImagesEntity]] = []
	@Published var users: [User] = []
	@Published var albums: Album = Album()
	
	@Published var visibleImages: [[ImagesEntity]] = []
	var tempVisibleImages: [[ImagesEntity]] = []
	@Published var visibleRoleImages: [[ImagesEntity]] = []
	var tempVisibleRoleImages: [[ImagesEntity]] = []
	
	var likeChk = false
	var images: [[ImagesEntity]] = []
	
	private var cancellables = Set<AnyCancellable>()
	
	/// 앨범 이미지 불러오기
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
				self.images.removeAll()
				self.albums = images
				var urls: [ImagesEntity] = []
				Task {
					try await self.fetchUser(userDocIds: images.users)
				}
				images.images.forEach { url in
					urls.append(url)
					if urls.count == 5 {
						self.images.append(urls)
						urls.removeAll()
					}
				}
				self.albumTitle = self.albums.albumTitle
				
				if !urls.isEmpty {
					self.images.append(urls)
				}
				
				self.visibleImages.removeAll()
				self.visibleRoleImages.removeAll()
				
				self.tempVisibleImages = self.images
				
				self.fetchState = true
				
				self.nextFetchImages()
			}
			.store(in: &cancellables)
	}
	
	@MainActor
	func afterLikeFetch(entityIndex: Int, entity: ImagesEntity) {
		if let index = visibleImages[entityIndex].firstIndex(where: { $0.fileName == entity.fileName }) {
			visibleImages[entityIndex][index] = entity
		}
	}
	
	@MainActor
	func nextFetchImages() {
		if !tempVisibleImages.isEmpty {
			visibleImages.append(tempVisibleImages.removeFirst())
		}
	}
	
	/// 역할 클릭
	@MainActor
	func fetchAlbumUserImages(uploadUserId: String) {
		visibleRoleImages.removeAll()
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
		
		self.tempVisibleRoleImages = roleImage
		self.nextFetchRoleImages()
	}
	
	@MainActor
	func nextFetchRoleImages() {
		if !tempVisibleRoleImages.isEmpty {
			visibleRoleImages.append(tempVisibleRoleImages.removeFirst())
		}
	}
	
	/// 유저 불러오기
	@MainActor
	func fetchUser(userDocIds: [String]) async throws {
		self.users = try await FirebaseService.fetchUser(userDocIds: userDocIds)
	}
	
	/// 좋아요 클릭
	func actionLike(toggleChk: Bool, albumDocId: String, fileName: String) async throws {
		_ = toggleChk ?
		try await FirebaseService.removeUserFromLikeUsers(albumDocId: albumDocId,
														  paramFileName: fileName) :
		try await FirebaseService.updateLikeUsers(albumDocId: albumDocId,
												  paramFileName: fileName)
		likeChk = true
	}
	
	/// 앨범 제목 수정
	@MainActor
	func updateAlbumTitle(albumDocId: String, title: String) async throws {
		if try await FirebaseService.updateAlbumTitle(albumDocId: albumDocId,
													  changedTitle: title) == .success {
			self.albumTitle = title
		}
	}
	
	/// 여행 종료
	func closedTravel(docId: String) async throws {
		if try await FirebaseService.closedTravel(albumDocId: docId) == .success { }
	}
	
	/// 여행 삭제
	func removeTravel(docId: String) async throws {
		if try await FirebaseService.removeTravel(albumDocId: docId) == .success { }
	}
	
	/// 앨범 대표 이미지 변경
	func updateAlbumCoverImage(albumDocId: String, url: String) async throws {
		if try await FirebaseService.updateAlbumCoverImage(albumDocId: albumDocId,
														   url: url) == .success { }
	}
	
	/// 이미지 삭제
	@MainActor
	func deleteAlbumImage(albumDocId: String, fileName: String) async throws {
		if try await FirebaseService.deleteAlbumImage(albumDocId: albumDocId,
													  parmFileName: fileName) == .success {
			self.fetchAlbumImages(albumDocId: albumDocId)
		}
	}
	
	/// sort
	func imageSort(state: Bool) {
		let sortState = state ? false : true
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
		
		visibleImages = visibleImages.map { $0.sorted { (img1, img2) -> Bool in
			if let date1 = formatter.date(from: img1.uploadTime),
			   let date2 = formatter.date(from: img2.uploadTime) {
				return sortState ? date1 > date2 : date1 < date2
			}
			return false
		}}
		
		visibleRoleImages = visibleRoleImages.map { $0.sorted { (img1, img2) -> Bool in
			if let date1 = formatter.date(from: img1.uploadTime),
			   let date2 = formatter.date(from: img2.uploadTime) {
				return sortState ? date1 > date2 : date1 < date2
			}
			return false
		}}
	}
	
	/// 내 역할 변경
	func changedMyRole(album: Album, role: String) async throws {
		_ = try await FirebaseService.changedMyRole(album: album, role: role)
	}
}
