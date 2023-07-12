//
//  FirebaseService.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/09.
//

import Combine
import UIKit

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

enum FirebaseState {
	case success
	case fail
}

struct FirebaseService {
	static let db = Firestore.firestore()
	
	//MARK: - User
	
	/// 회원가입
	static func signup(user: User) async throws -> FirebaseState {
		var userData: [String: Any] = [
			"id": user.id,
			"email": user.email,
			"password": user.password,
			"code": user.code,
			"isFirstLogin": user.isFirstLogin,
			"nickname": user.nickname,
			"profileImage": user.profileImage,
			"progressAlbum": user.progressAlbum,
			"finishedAlbum": user.finishedAlbum,
			"notification": user.notification
		]
		userData = userData.compactMapValues { $0 }
		let collectionRef = db.collection("User")
		let documentRef = collectionRef.addDocument(data: userData) { error in
			if let error = error {
				print("error \(error.localizedDescription)")
				return
			}
		}
		let documentID = documentRef.documentID
		do {
			try KeyChainManager.shared.create(account: .documentId, documentId: documentID)
		} catch {
			print(KeyChainError.itemNotFound)
			return .fail
		}
		return .success
	}
	
	/// 로그인
	static func signin(loginId: String, password: String) async throws -> FirebaseState {
		return try await withUnsafeThrowingContinuation { configuration in
			db.collection("User").getDocuments {snapsot, error in
				if error != nil {
					configuration.resume(returning: .fail)
					return
				}
				guard let snapsot else {
					print(FirebaseError.badsnapshot)
					configuration.resume(returning: .fail)
					return
				}
				snapsot.documents.forEach { document in
					let data = document.data()
					let getId = data["id"] as? String ?? ""
					if loginId == getId {
						do {
							try KeyChainManager.shared.create(account: .documentId,
															  documentId: document.documentID)
							configuration.resume(returning: .success)
						} catch {
							print(KeyChainError.itemNotFound)
							configuration.resume(returning: .fail)
							return
						}
					}
				}
			}
		}
	}
	
	/// 닉네임 변경
	static func updateNickname(updatedNickname: String) async throws -> FirebaseState {
		do {
			let id = try KeyChainManager.shared.read(account: .documentId)
			let documentRef = db.collection("User").document(id)
			return try await withUnsafeThrowingContinuation { configuration in
				documentRef.updateData([
					"nickname": updatedNickname
				]) { error in
					print(KeyChainError.itemNotFound)
					configuration.resume(returning: .fail)
				}
				configuration.resume(returning: .success)
			}
		} catch {
			print(KeyChainError.itemNotFound)
		}
		return .fail
	}
	
	/// 프로필 이미지 변경
	static func updateProfileImage(image: UIImage) async throws -> FirebaseState {
		let data = image.jpegData(compressionQuality: 0.5)!
		let storage = Storage.storage()
		let metaData = StorageMetadata()
		metaData.contentType = "image/png"
		storage.reference().child("album/" + "UUID").putData(data, metadata: metaData) { (metaData, error) in
			if let error = error {
				print("error \(error.localizedDescription)")
				return
			} else {
				storage.reference().child("album1/" + "test2").downloadURL { URL, error in
					guard let URL else { return }
					do {
						let id = try KeyChainManager.shared.read(account: .documentId)
						let path = db.collection("User").document(id)
						path.updateData(["profileImage" : String(describing: URL)])
					} catch {
						print(KeyChainError.itemNotFound)
						return
					}
				}
			}
		}
		return .success
	}
	
	/// 유저정보 불러오기
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
	
	/// 회원탈퇴
	static func withdrawalUser() async throws -> FirebaseState {
		do {
			let id = try KeyChainManager.shared.read(account: .documentId)
			let documentRef = db.collection("User").document(id)
			return try await withUnsafeThrowingContinuation { configuration in
				documentRef.delete { error in
					if let error = error {
						configuration.resume(returning: .fail)
					} else {
						do {
							try KeyChainManager.shared.delete(account: .documentId)
							configuration.resume(returning: .success)
						} catch {
							print(KeyChainError.itemNotFound)
							configuration.resume(returning: .fail)
						}
					}
				}
			}
		} catch {
			print(KeyChainError.itemNotFound)
		}
		return .fail
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
