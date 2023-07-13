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
					if error != nil {
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
	
	//MARK: - Album
	
	/// 앨범에 이미지 올리기
	static func uploadAlbumImage(image: UIImage, albumDocId: String) async throws -> FirebaseState {
		let data = image.jpegData(compressionQuality: 0.5)!
		let storage = Storage.storage()
		let metaData = StorageMetadata()
		metaData.contentType = "image/png"
		return try await withUnsafeThrowingContinuation { configuration in
			storage.reference().child("album1/" + "test4").putData(data, metadata: metaData) { ( metaData, error ) in
				if let error = error {
					configuration.resume(returning: .fail)
					return
				} else {
					storage.reference().child("album1/" + "test4").downloadURL { URL, error in
						guard let URL else { return }
						let updatedData: [String: Any] = [
							"images": FieldValue.arrayUnion([
								["comment" : "설명 테스트2",
								 "fileName" : "파일 이름2",
								 "url" : String(describing: URL),
								 "reaction" : ["bad" : 0, "like" : 0]] as [String : Any]
							])
						]
						let path = db.collection("album").document(albumDocId)
						path.updateData(updatedData)
						configuration.resume(returning: .success)
					}
				}
			}
		}
	}
	
	/// 앨범 이미지 가져오기
	static func fetchAlbumImages(albumDocId: String) -> AnyPublisher<Bool, Error> {
		Future<Bool, Error> { promise in
			db.collection("album").getDocuments { snapshot, error in
				if let error {
					promise(.failure(error))
					return
				}
				guard let snapshot else {
					promise(.failure(FirebaseError.badsnapshot))
					return
				}
				if let document = snapshot.documents.first(where: { $0.documentID == albumDocId }) {
					let data = document.data()
					if let images = data["images"] as? [[String: Any]] {
						let urls = images.compactMap { $0["url"] as? String }
					}
					promise(.success(true))
				} else {
					promise(.failure(FirebaseError.badsnapshot))
					return
				}
			}
		}
		.eraseToAnyPublisher()
	}
	
	/// 앨범 이미지 변경
	static func updateAlbumImage(image: UIImage, albumDocId: String) async throws -> FirebaseState {
		let data = image.jpegData(compressionQuality: 0.5)!
		let storage = Storage.storage()
		let metaData = StorageMetadata()
		metaData.contentType = "image/png"
		return try await withUnsafeThrowingContinuation { configuration in
			storage.reference().child("album1/" + "test4").delete { error in
				if let error = error {
					configuration.resume(returning: .fail)
					return
				}
			}
			storage.reference().child("album1/" + "test5").putData(data, metadata: metaData) { ( metaData, error ) in
				if error != nil {
					configuration.resume(returning: .fail)
					return
				} else {
					storage.reference().child("album1/" + "test5").downloadURL { URL, error in
						guard let URL else { return }
						let path = db.collection("album").document(albumDocId)
						path.getDocument { snapshot, error in
							guard let document = snapshot, document.exists else {
								configuration.resume(returning: .fail)
								return
							}
							
							if var images = document.data()?["images"] as? [[String: Any]] {
								for (index, image) in images.enumerated() {
									if let fileName = image["fileName"] as? String, fileName == "파일 이름2" {
										images[index]["url"] = String(describing: URL)
									}
								}
								
								let updatedData: [String: Any] = [
									"images": images
								]
								
								path.updateData(updatedData) { error in
									if let error = error {
										configuration.resume(returning: .fail)
									}
									configuration.resume(returning: .success)
								}
							}
						}
					}
				}
			}
		}
	}
	
	/// 앨범 이미지 삭제
	static func deleteAlbumImage(albumDocId: String) async throws -> FirebaseState {
		return try await withUnsafeThrowingContinuation { configuration in
			let storage = Storage.storage()
			storage.reference().child("album1/" + "test2").delete { error in
				if let error = error {
					print("Error deleting file: \(error)")
				} else {
					print("File deleted successfully.")
				}
			}
			
			storage.reference().child("album1/" + "test2").downloadURL { URL, error in
				guard let URL else { return }
				print("URL \(String(describing: URL))")
				let path = db.collection("album").document(albumDocId)
				path.getDocument { snapshot, error in
					guard let document = snapshot, document.exists else {
						configuration.resume(returning: .fail)
						return
					}
					
					if var images = document.data()?["images"] as? [[String: Any]] {
						images.removeAll { image in
							if let fileName = image["fileName"] as? String, fileName == "123" {
								return true
							}
							return false
						}
						
						let updatedData: [String: Any] = [
							"images": images
						]
						
						path.updateData(updatedData) { error in
							if let error = error {
								print("Error updating document: \(error)")
							} else {
								print("Document updated successfully.")
							}
							configuration.resume(returning: .success)
						}
					}
				}
			}
		}
	}
}
