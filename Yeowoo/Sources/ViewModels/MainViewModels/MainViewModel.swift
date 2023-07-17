//
//  MainViewModel.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/17.
//

import SwiftUI

struct Dummy: Identifiable, Hashable {
    var id = UUID()
    var albumName: String
    var startDay: String
    var endDay: String
    var withPerson: [Color]
    var isTraveling: Bool
}

let dummyData = [Dummy(albumName: "일본 여행", startDay: "2023.02.11", endDay: "2023.02.15", withPerson: [.purple, .pink], isTraveling: false),
                 Dummy(albumName: "경주 여행", startDay: "2023.03.30", endDay: "2023.07.16", withPerson: [.purple, .blue, .brown, .cyan, .green], isTraveling: false)]

//var travelData = Dummy(albumName: "서울 여행", startDay: "2023.05.20", endDay: "2023.05.23", withPerson: [.purple], isTraveling: true)
var travelData = Dummy(albumName: "", startDay: "", endDay: "", withPerson: [], isTraveling: true)

let Colors: [Color] = [.brown, .black, .pink, .teal, .yellow, .cyan, .primary]

func hasTraveling() -> Bool {
    
    if travelData.albumName == "" {
        return false
    }
    return true
}

func getCurrentDateTime(_ str: inout String) {
    let formatter = DateFormatter() //객체 생성
    formatter.dateStyle = .long
    formatter.timeStyle = .medium
    formatter.dateFormat = "yyyy.MM.dd" //데이터 포멧 설정
    str = formatter.string(from: Date()) //문자열로 바꾸기
}

func randomPicture(_ album: [Color] , _ pic: inout [Color]){
    var three: [Color] = [.blue, .blue, .blue]
    var one: Color
    var isHave = false
    for i in 0..<3{
        one = album.randomElement()!
        
        while true {
            for j in 0..<i {
                if three[j] == one {
                    one = album.randomElement()!
                    isHave = true
                    break
                }
            }
            if isHave {
                isHave = false
                continue
            } else {
                break
            }
        }
        three[i] = one
    }
    for k in 0..<3 {
        pic[k] = three[k]
        print(pic[k])
    }
}
