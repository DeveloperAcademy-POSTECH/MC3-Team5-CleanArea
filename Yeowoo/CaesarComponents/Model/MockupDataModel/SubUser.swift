//
//  User.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/17.
//

import Foundation


//User가 정의되어있어서 SubUser라고 해둘게요
struct SubUser: Identifiable {
    let id = UUID()
    var username: String
    var nickname: String
    var profileImageUrl: String
}

let users = [
        SubUser(username: "시저", nickname: "Caesar", profileImageUrl: "Caesar" ),
        SubUser(username: "노바", nickname: "Nova", profileImageUrl: "Nova"),
        SubUser(username: "제이미", nickname: "Jamie", profileImageUrl: "Jamie"),
        SubUser(username: "핀", nickname: "Pin", profileImageUrl: "Pin"),
        SubUser(username: "지구", nickname: "Jigu", profileImageUrl: "Jigu"),
        SubUser(username: "아지", nickname: "Azhy", profileImageUrl: "Azhy"),
        SubUser(username: "썬데이", nickname: "Sunday", profileImageUrl: "Sunday"),
]
