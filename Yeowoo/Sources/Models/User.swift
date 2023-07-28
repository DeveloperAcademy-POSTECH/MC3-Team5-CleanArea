//
//  User.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/10.
//

import Foundation

struct User: Identifiable {
	let docId: String // docId
	let id: String	// id
	let email: String	// email
	let password: String	// password
	let isFirstLogin: Bool	// 첫 로그인
	let nickname: String	// 닉네임
	let profileImage: String	// 프로필 사진 url
	let progressAlbum: String	// 현재 여행 중 앨범 id
	let finishedAlbum: [String]	// 종료된 여행 앨범 id
	let notification: [Notification]	// 알림
	let fcmToken: String	// fcmToken
	
	init(docId: String = "",
		 id: String = "",
		 email: String = "",
		 password: String = "",
		 isFirstLogin: Bool = false,
		 nickname: String = "",
		 profileImage: String = "",
		 progressAlbum: String = "",
		 finishedAlbum: [String] = [],
		 notification: [Notification] = [],
		 fcmToken: String = "") {
		self.docId = docId
		self.id = id
		self.email = email
		self.password = password
		self.isFirstLogin = isFirstLogin
		self.nickname = nickname
		self.profileImage = profileImage
		self.progressAlbum = progressAlbum
		self.finishedAlbum = finishedAlbum
		self.notification = notification
		self.fcmToken = fcmToken
	}
	
	init?(documentData: [String: Any]) {
		guard let docId = documentData["docId"] as? String,
			  let id = documentData["id"] as? String,
			  let email = documentData["email"] as? String,
			  let password = documentData["password"] as? String,
			  let isFirstLogin = documentData["isFirstLogin"] as? Bool,
			  let nickname = documentData["nickname"] as? String,
			  let profileImage = documentData["profileImage"] as? String,
			  let progressAlbum = documentData["progressAlbum"] as? String,
			  let finishedAlbum = documentData["finishedAlbum"] as? [String],
			  let notification = documentData["notification"] as? [Notification],
			  let fcmToken = documentData["fcmToken"] as? String else {
			return nil
		}
		
		self.init(docId: docId,
				  id: id,
				  email: email,
				  password: password,
				  isFirstLogin: isFirstLogin,
				  nickname: nickname,
				  profileImage: profileImage,
				  progressAlbum: progressAlbum,
				  finishedAlbum: finishedAlbum,
				  notification: notification,
				  fcmToken: fcmToken)
	}
}
