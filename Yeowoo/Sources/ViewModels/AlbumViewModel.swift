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
	
	private var cancellables = Set<AnyCancellable>()
	
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
				print("images \(images)")
				var urls: [ImagesEntity] = []
				images.forEach { url in
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
