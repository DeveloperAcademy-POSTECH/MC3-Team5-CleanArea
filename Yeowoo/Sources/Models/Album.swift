//
//  Album.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/14.
//

import Foundation

struct Album: Identifiable, Hashable {
	var id: String // docId
	var albumTitle: String // 앨범 제목
	var albumCoverImage: String // 앨범 커버 url
	var startDay: String // 여행 시작 시간
	var endDay: String // 여행 끝난 시간
	var images: [ImagesEntity]
	var isClosed: Bool // 종료 여부
	var users: [String] // 소속된 유저들
	var role: [String] // role
	
	init(id: String = "",
		 albumTitle: String = "",
		 albumCoverImage: String = "",
		 startDay: String = "",
		 endDay: String = "",
		 images: [ImagesEntity] = [],
		 isClosed: Bool = false,
		 users: [String] = [],
		 role: [String] = []) {
		self.id = id
		self.albumTitle = albumTitle
		self.albumCoverImage = albumCoverImage
		self.startDay = startDay
		self.endDay = endDay
		self.images = images
		self.isClosed = isClosed
		self.users = users
		self.role = role
	}
}

struct ImagesEntity: Hashable {
    let comment: String    // 설명
    let fileName: String    // storage 파일 이름
    let url: String    // url
    let uploadUser: String    // 업로드 한 유저
    let roleCheck: Bool    // 역할 확인
    var likeUsers: [String] // 좋아요 한 유저들
    let uploadTime: String // 올린 시간 (수정한 시간)
}

