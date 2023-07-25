//
//  Fopx.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/17.
//

import Foundation

struct Fox{
    let foxName: String
    var description: String
    var foxImage: String
}

let foxs = [
    Fox(foxName: "그냥 여우", description: "나는 그냥 여우\n내맘대로 할거여우", foxImage: "normalFox"),
    Fox(foxName: "먹방 여우", description: "추억이 담긴 맛을\n기록해요", foxImage: "eatFox"),
    Fox(foxName: "액티비티 여우", description: "활동적인 순간을\n포착해요", foxImage: "activityFox"),
    Fox(foxName: "풍경 여우", description: "자연과 건축물의\n아름다움을 담아요", foxImage: "sceneryFox"),
    Fox(foxName: "파파라치 여우", description: "친구들의 은밀한\n순간을 몰래 포착해요", foxImage: "paparazziFox"),
    Fox(foxName: "대장 여우", description: "친구들이 모두 함께\n하는 사진을 담아요", foxImage: "captainFox"),
]
