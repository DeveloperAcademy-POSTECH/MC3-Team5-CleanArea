//
//  FirebaseService.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/09.
//

import Combine
import Foundation

import FirebaseFirestore
import FirebaseFirestoreSwift

struct FirebaseService {
	static let db = Firestore.firestore()
	
	static func fetchTest() -> AnyPublisher<[Test], Error> {
		Future<[Test], Error> { promise in
			db.collection("Test").getDocuments { snapsot, error in
				if let error = error {
					promise(.failure(error))
					return
				}
				
				guard let snapsot else {
					promise(.failure(FirebaseError.badsnapshot))
					return
				}
				
				var tests: [Test] = []
				snapsot.documents.forEach { document in
					let data = document.data()
					
					let code = data["code"] as? String ?? ""
					let finishedAlbum = data["finishedAlbum"] as? [String] ?? []
					let id = data["id"] as? String ?? ""
					let isFirstLogin = data["isFirstLogin"] as? Bool ?? false
					let nickname = data["nickname"] as? String ?? ""
					let profileImage = data["profileImage"] as? String ?? ""
					let progressAlbum = data["progressAlbum"] as? String ?? ""
					let test = Test(code: code,
									finishedAlbum: finishedAlbum,
									id: id,
									isFirstLogin: isFirstLogin,
									nickname: nickname,
									profileImage: profileImage,
									progressAlbum: progressAlbum)
					tests.append(test)
				}
				promise(.success(tests))
			}
		}
		.eraseToAnyPublisher()
	}
}
