//
//  User.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/17.
//

import Foundation

struct Push: Identifiable {
	let id = UUID()
	var content: String
}

let pushs = [
		Push(content: "오늘 소중한 순간을 얼마나 담으셨나요?📸"),
		Push(content: "지금 이 순간 가장 인상적인것을 찰칵!🤩"),
		Push(content: "오늘의 즐거운 기록을 깜빡하지 마세요!"),
		Push(content: "지금 이 순간 가장 인상적인것을 찰칵!🤩"),
		Push(content: "눈 앞에 가장 아름다운 것은 무엇인가요?!👀"),
		Push(content: "지금 바로 임무에 충실할 때!😎"),
		Push(content: "여행 중의 우리의 순간을 모아주세요😆"),
		Push(content: "여우는 배가 고파요🫠 사진을 주세요!"),
		Push(content: "모든 순간을 소중히 찰칵❤️"),
		Push(content: "지금이 바로 사진찍기 좋은 순간😋"),
]
