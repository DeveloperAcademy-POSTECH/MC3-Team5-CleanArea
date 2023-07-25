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
	
	var likeChk = false
	
	@Published var albumTitle = ""
	@Published var fetchState = false
	@Published var roleImage: [[ImagesEntity]] = []
	@Published var users: [User] = []
	@Published var images: [[ImagesEntity]] = []
	@Published var albums: Album = Album()
	
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
				self.fetchUser(userDocIds: images.users)
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
				
				self.fetchState = true
			}
			.store(in: &cancellables)
	}
	
	/// 유저 불러오기
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
	
	/// 역할 클릭
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
	
	/// 태스트 이미지 업로드용
	func testUpload() async throws {
		_ = try await FirebaseService.uploadAlbumImage(image: UIImage(named: "9")!,
													   albumDocId: "T9eJMPQEGQClFHEahX6r",
													   fileName: String(describing: UUID()))
	}
	
	/// sort
	func imageSort(state: Bool) {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
		
		images = images.map { $0.sorted { (img1, img2) -> Bool in
			if let date1 = formatter.date(from: img1.uploadTime),
			   let date2 = formatter.date(from: img2.uploadTime) {
				return state ? date1 > date2 : date1 < date2
			}
			return false
		}}
	}
}
