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
	
	//MARK: - User
	
	static func signup(user: User) -> AnyPublisher<User, Error> {
		Future<User, Error> { promise in
			var userData: [String: Any] = [
				"email": user.email,
				"password": user.password,
				"code": user.code,
				"isFirstLogin": user.isFirstLogin,
				"nickname": user.nickname,
				"profileImage": user.profileImage,
				"progressAlbum": user.progressAlbum,
				"finishedAlbum": user.finishedAlbum
			]
			
			userData = userData.compactMapValues { $0 }
			
			let collectionRef = db.collection("User")
			let documentRef = collectionRef.addDocument(data: userData) { error in
				if let error = error {
					promise(.failure(error))
				}
			}
			
			let documentID = documentRef.documentID
			
			do {
				try KeyChainManager.shared.create(account: .documentId, documentId: documentID)
			} catch {
				print(KeyChainError.itemNotFound)
			}
			promise(.success(user))
		}
		.eraseToAnyPublisher()
	}
	
	static func signin(email: String, password: String) -> AnyPublisher<Bool, Error> {
		Future<Bool, Error> { promise in
			db.collection("User").getDocuments { snapsot, error in
				if let error = error {
					promise(.failure(error))
					return
				}
				
				guard let snapsot else {
					promise(.failure(FirebaseError.badsnapshot))
					return
				}
				
				snapsot.documents.forEach { document in
					let data = document.data()
					let docEmail = data["email"] as? String ?? ""
					if docEmail == email {
						do {
							try KeyChainManager.shared.create(account: .documentId,
															  documentId: document.documentID)
						} catch {
							print(KeyChainError.itemNotFound)
						}
					}
				}
				promise(.success(true))
			}
		}
		.eraseToAnyPublisher()
	}
	
	// 추후에 update user 요소들 추가 (profileImage...)
	static func updateNickname(updatedNickname: String) -> AnyPublisher<User, Error> {
		Future<User, Error> { promise in
			do {
				let id = try KeyChainManager.shared.read(account: .documentId)
				let documentRef = db.collection("User").document(id)
				documentRef.updateData([
					"nickname": updatedNickname
				]) { error in
					print(KeyChainError.itemNotFound)
				}
			} catch {
				print(KeyChainError.itemNotFound)
			}
		}
		.eraseToAnyPublisher()
	}
	
	static func fetchUser() -> AnyPublisher<User, Error> {
		Future<User, Error> { promise in
			do {
				let documentId = try KeyChainManager.shared.read(account: .documentId)
				db.collection("User").getDocuments { snapshot, error in
					if let error {
						promise(.failure(error))
						return
					}
					guard let snapshot else {
						promise(.failure(FirebaseError.badsnapshot))
						return
					}
					if let document = snapshot.documents.first(where: { $0.documentID == documentId }) {
						let data = document.data()
						if let user = User(documentData: data) {
							promise(.success(user))
						}
					} else {
						promise(.failure(FirebaseError.badsnapshot))
						return
					}
				}
			} catch {
				print(KeyChainError.itemNotFound)
			}
		}
		.eraseToAnyPublisher()
	}
	
	//MARK: - Test
	
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
