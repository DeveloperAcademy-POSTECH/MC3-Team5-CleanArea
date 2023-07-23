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
	
	/// 아이디 중복확인
	static func idDuplicateCheck(id: String) async throws -> FirebaseState {
		
		let query = db.collection("User").whereField("id", isEqualTo: id)
		let querySnapshot = try await query.getDocuments()
		
		if !querySnapshot.isEmpty {
			print("아이디 중복")
			// 아이디 중복됨
			return .fail
		} else {
			print("아이디 중복 안됨")
			// 아이디 중복 안됨
			return .success
		}
	}
	
	/// 회원가입
	static func signup(user: User) async throws -> FirebaseState {
		var userData: [String: Any] = [
			"docId": "",
			"id": user.id,
			"email": user.email,
			"password": user.password,
			"isFirstLogin": user.isFirstLogin,
			"nickname": user.nickname,
			"profileImage": user.profileImage,
			"progressAlbum": user.progressAlbum,
			"finishedAlbum": user.finishedAlbum,
			"notification": user.notification,
			"fcmToken": user.fcmToken
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
			UserDefaultsSetting.userDocId = documentID
			updateDocId(docId: documentID)
		} catch {
			print(KeyChainError.itemNotFound)
			return .fail
		}
		return .success
	}
	
	/// 로그인
	static func signin(loginId: String, password: String) async throws -> FirebaseState {
		return try await withUnsafeThrowingContinuation { configuration in
			var chk = false
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
					let getPwd = data["password"] as? String ?? ""
					if loginId == getId {
						if password == getPwd {
							do {
								try KeyChainManager.shared.create(account: .documentId,
																  documentId: document.documentID)
								UserDefaultsSetting.userDocId = document.documentID
								chk = true
							} catch {
								print(KeyChainError.itemNotFound)
								configuration.resume(returning: .fail)
								return
							}
						}
					}
				}
				configuration.resume(returning: chk ? .success : .fail)
			}
		}
	}
	
	/// docId 세팅
	static func updateDocId(docId: String) {
		let documentRef = db.collection("User").document(docId)
		documentRef.updateData([
			"docId": docId
		]) { error in
			print(KeyChainError.itemNotFound)
		}
	}
	
	/// user fcmToken 세팅
	static func updateFCMToken(fcmToken: String) {
		do {
			let id = try KeyChainManager.shared.read(account: .documentId)
			let documentRef = db.collection("User").document(id)
			documentRef.updateData([
				"fcmToken": fcmToken
			]) { error in
				print(KeyChainError.itemNotFound)
			}
		} catch {
			print(KeyChainError.itemNotFound)
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
	static func fetchUser(userDocIds: [String] = []) -> AnyPublisher<[User], Error> {
		Future<[User], Error> { promise in
			var users: [User] = []
			//				let documentId = userDocIds.isEmpty ? try KeyChainManager.shared.read(account: .documentId) : userDocIds
			db.collection("User").getDocuments { snapshot, error in
				if let error {
					promise(.failure(error))
					return
				}
				guard let snapshot else {
					promise(.failure(FirebaseError.badsnapshot))
					return
				}
				if userDocIds.isEmpty {
					do {
						let documentId = try KeyChainManager.shared.read(account: .documentId)
						if let document = snapshot.documents.first(where: { $0.documentID == documentId }) {
							let data = document.data()
							users.append(User(documentData: data)!)
							promise(.success(users))
							//								if let user = User(documentData: data) {
							//									promise(.success(user))
							//								}
						} else {
							promise(.failure(FirebaseError.badsnapshot))
							return
						}
					} catch {
						print(KeyChainError.itemNotFound)
					}
				} else {
					for id in userDocIds {
						print("not empty \(id)")
						//							snapshot.documents["id"].data()
						print(snapshot.documents.first!.documentID)
						print(id)
						if let document = snapshot.documents.first(where: { $0.documentID == id }) {
							let data = document.data()
							print("data \(data)")
							users.append(User(documentData: data)!)
						}
					}
					promise(.success(users))
				}
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
			storage.reference().child("album1/" + "setindex").putData(data, metadata: metaData) { ( metaData, error ) in
				if error != nil {
					configuration.resume(returning: .fail)
					return
				} else {
					storage.reference().child("album1/" + "setindex").downloadURL { URL, error in
						guard let URL else { return }
						let updatedData: [String: Any] = [
							// 수정
							"images": FieldValue.arrayUnion([
								["comment" : "설명 테스트 index",
								 "fileName" : "파일 이름 index",
								 "url" : String(describing: URL),
								 "likeUsers": [],
								 "roleCheck": true,
								 "updateTime": "0",
								 "uploadUser": ""] as [String : Any]
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
	static func fetchAlbumImages(albumDocId: String) -> AnyPublisher<Album, Error> {
		Future<Album, Error> { promise in
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
					if let imagesData = data["images"] as? [[String: Any]] {
						var images: [ImagesEntity] = []
						let isClosed = data["isClosed"] as! Bool
						let users: [String] = (data["users"] as? [String])!
						let albumTitle: String = data["title"] as! String
						let albumCoverImage: String = data["coverImage"] as! String
						let startDay: String = data["startDay"] as! String
						let endDay: String = data["endDay"] as! String
						let role: [String] = data["role"] as! [String]
						for imageData in imagesData {
							if let comment = imageData["comment"] as? String,
							   let fileName = imageData["fileName"] as? String,
							   let likeUsers = imageData["likeUsers"] as? [String],
							   let updateTime = imageData["updateTime"] as? String,
							   let url = imageData["url"] as? String,
							   let uploadUser = imageData["uploadUser"] as? String,
							   let roleCheck = imageData["roleCheck"] as? Bool {
								
								let image = ImagesEntity(comment: comment, fileName: fileName,
														 url: url, uploadUser: uploadUser,
														 roleCheck: roleCheck, likeUsers: likeUsers,
														 uploadTime: updateTime)
								images.append(image)
							}
						}
						promise(.success(Album(id: document.documentID, albumTitle: albumTitle,
											   albumCoverImage: albumCoverImage, startDay: startDay,
											   endDay: endDay, images: images, isClosed: isClosed, users: users, role: role)))
					}
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
				if error != nil {
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
									if error != nil {
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
	
	// 앨범 제목 변경
	static func updateAlbumTitle(albumDocId: String, changedTitle: String) async throws -> FirebaseState {
		let documentRef = db.collection("album").document(albumDocId)
		return try await withUnsafeThrowingContinuation { configuration in
			documentRef.updateData([
				"title": changedTitle
			])
			configuration.resume(returning: .success)
		}
	}
	
	// 여행 종료하기 -> 여행 컬렉션 관련
	static func closedTravel(albumDocId: String) async throws -> FirebaseState {
		let albumDocumentRef = db.collection("album").document(albumDocId)
		return try await withUnsafeThrowingContinuation { configuration in
			albumDocumentRef.updateData([
				"isClosed": true
			])
			
			albumDocumentRef.getDocument { snapshot, error in
				guard let document = snapshot, document.exists else {
					configuration.resume(returning: .fail)
					return
				}
				
				// 각 유저들 여행 progressAlbum "" + finishedAlbum에 추가
				
				(document.data()?["users"] as? [String])?.forEach { docId in
					let userDocumentRef = db.collection("User").document(docId)
					userDocumentRef.updateData(["progressAlbum": "1"]) { error in
						if let error = error {
							print("Error updating user document: \(error)")
							configuration.resume(returning: .fail)
							return
						}
						
						// albumDocId 추가 코드
						userDocumentRef.updateData([
							"finishedAlbum": FieldValue.arrayUnion([albumDocId])
						])
					}
				}
			}
			configuration.resume(returning: .success)
		}
	}
	
	// 여행 삭제하기
	static func removeTravel(albumDocId: String) async throws -> FirebaseState {
		do {
			let id = try KeyChainManager.shared.read(account: .documentId)
			let documentRef = db.collection("User").document(id)
			return try await withUnsafeThrowingContinuation { configuration in
				documentRef.getDocument { snapshot, error in
					guard let document = snapshot, document.exists else {
						configuration.resume(returning: .fail)
						return
					}
					if var finishedAlbum = document.data()?["finishedAlbum"] as? [String] {
						// Remove albumDocId from finishedAlbum if it exists
						finishedAlbum.removeAll { $0 == albumDocId }
						
						// Update the finishedAlbum in the Firestore document
						documentRef.updateData(["finishedAlbum": finishedAlbum]) { error in
							if let error = error {
								print("Error updating user document: \(error)")
								configuration.resume(returning: .fail)
							} else {
								print("Document updated successfully.")
								configuration.resume(returning: .success)
							}
						}
					} else {
						configuration.resume(returning: .fail)
					}
				}
			}
		} catch {
			print(KeyChainError.itemNotFound)
		}
		return .fail
	}
	
	// 대표 이미지 변경
	static func updateAlbumCoverImage(albumDocId: String, url: String) async throws -> FirebaseState {
		let documentRef = db.collection("album").document(albumDocId)
		return try await withUnsafeThrowingContinuation { configuration in
			documentRef.updateData([
				"coverImage": url
			])
			configuration.resume(returning: .success)
		}
	}
	
	// 좋아요 등록
	static func updateLikeUsers(albumDocId: String, paramFileName: String) async throws -> FirebaseState {
		return try await withUnsafeThrowingContinuation { configuration in
			let path = db.collection("album").document(albumDocId)
			path.getDocument { snapshot, error in
				guard let document = snapshot, document.exists else {
					configuration.resume(returning: .fail)
					return
				}
				
				if var images = document.data()?["images"] as? [[String: Any]] {
					for index in 0..<images.count {
						if let fileName = images[index]["fileName"] as? String, fileName == paramFileName {
							var likeUsers = images[index]["likeUsers"] as? [String] ?? []
							if !likeUsers.contains(UserDefaultsSetting.userDocId) {
								likeUsers.append(UserDefaultsSetting.userDocId)
								images[index]["likeUsers"] = likeUsers
							}
						}
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
	
	// 좋아요 삭제
	static func removeUserFromLikeUsers(albumDocId: String, paramFileName: String) async throws -> FirebaseState {
		return try await withUnsafeThrowingContinuation { configuration in
			let path = db.collection("album").document(albumDocId)
			path.getDocument { snapshot, error in
				guard let document = snapshot, document.exists else {
					configuration.resume(returning: .fail)
					return
				}
				
				if var images = document.data()?["images"] as? [[String: Any]] {
					for index in 0..<images.count {
						if let fileName = images[index]["fileName"] as? String, fileName == paramFileName {
							var likeUsers = images[index]["likeUsers"] as? [String] ?? []
							if let userIndex = likeUsers.firstIndex(of: UserDefaultsSetting.userDocId) {
								likeUsers.remove(at: userIndex)
								images[index]["likeUsers"] = likeUsers
							}
						}
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
