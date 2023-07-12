//
//  User.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/10.
//

import Foundation

struct User: Identifiable {
	let id: String	// id
	let email: String	// email
	let password: String	// password
	let code: String	// 친구 초대 code
	let isFirstLogin: Bool	// 첫 로그인
	let nickname: String	// 닉네임
	let profileImage: String	// 프로필 사진 url
	let progressAlbum: String	// 현재 여행 중 앨범 id
	let finishedAlbum: [String]	// 종료된 여행 앨범 id
	let notification: [String]	// 알림
	
	init(id:String, email: String, password: String, code: String, isFirstLogin: Bool,
		 nickname: String, profileImage: String, progressAlbum: String,
		 finishedAlbum: [String], notification: [String]) {
		self.id = id
		self.email = email
		self.password = password
		self.code = code
		self.isFirstLogin = isFirstLogin
		self.nickname = nickname
		self.profileImage = profileImage
		self.progressAlbum = progressAlbum
		self.finishedAlbum = finishedAlbum
		self.notification = notification
	}
	
	init?(documentData: [String: Any]) {
		guard let id = documentData["id"] as? String,
			  let email = documentData["email"] as? String,
			  let password = documentData["password"] as? String,
			  let code = documentData["code"] as? String,
			  let isFirstLogin = documentData["isFirstLogin"] as? Bool,
			  let nickname = documentData["nickname"] as? String,
			  let profileImage = documentData["profileImage"] as? String,
			  let progressAlbum = documentData["progressAlbum"] as? String,
			  let finishedAlbum = documentData["finishedAlbum"] as? [String],
			  let notification = documentData["notification"] as? [String] else {
			return nil
		}
		
		self.init(id: id,
				  email: email,
				  password: password,
				  code: code,
				  isFirstLogin: isFirstLogin,
				  nickname: nickname,
				  profileImage: profileImage,
				  progressAlbum: progressAlbum,
				  finishedAlbum: finishedAlbum,
				  notification: notification)
	}
}
