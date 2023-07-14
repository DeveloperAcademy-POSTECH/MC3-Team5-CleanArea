//
//  Album.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/14.
//

import Foundation

struct Album {
	var images: [ImagesEntity]
	var isClosed: Bool
	var users: [String]
}

struct ImagesEntity {
	let comment: String	// 설명
	let fileName: String	// storage 파일 이름
	let like: Int	// 좋아요 수
	let url: String	// url
}
