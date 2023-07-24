//
//  Album.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/14.
//

import Foundation

// 전부 다 ? 붙이는게 좋음

struct Album: Identifiable, Hashable {
    var id: String // album DocId
    var albumTitle: String // 앨범 제목
    var albumCoverImage: String // 앨범 커버 url
    var startDay: String // 여행 시작 시간
    var endDay: String // 여행 끝난 시간
    var images: [ImagesEntity]
    var isClosed: Bool
    var users: [String]
    var role: [String]
}

struct ImagesEntity: Hashable {
    let comment: String    // 설명
    let fileName: String    // storage 파일 이름
    let url: String    // url
    let uploadUser: String    // 업로드 한 유저
    let roleCheck: Bool    // 역할 확인
    let likeUsers: [String] // 좋아요 한 유저들
    let uploadTime: String // 올린 시간 (수정한 시간)
}

