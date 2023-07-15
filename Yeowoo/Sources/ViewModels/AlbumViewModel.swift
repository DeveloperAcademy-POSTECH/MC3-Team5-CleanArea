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
	
	@Published var images: [[ImagesEntity]] = []
	@Published var albums: Album = Album(images: [], isClosed: false, users: [])
	
	private var cancellables = Set<AnyCancellable>()
	
	// 유저별 이미지는 유저 이미지 전체를 불러와야해서.. 다시 불러와야할듯..
	@MainActor
	func fetchAlbumImages(albumDocId: String) {
		FirebaseService.fetchAlbumImages(albumDocId: "T9eJMPQEGQClFHEahX6r")
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
				images.images.forEach { url in
					urls.append(url)
					if urls.count == 5 {
						self.images.append(urls)
						urls.removeAll()
					}
				}
				self.images.append(urls)
			}
			.store(in: &cancellables)
	}
	
//	func upload() async throws {
//		print("???")
//		for i in 10..<20 {
//			try await FirebaseService.uploadAlbumImage(image: UIImage(named: "14")!, albumDocId: "T9eJMPQEGQClFHEahX6r", index: i)
//		}
//	}
}
