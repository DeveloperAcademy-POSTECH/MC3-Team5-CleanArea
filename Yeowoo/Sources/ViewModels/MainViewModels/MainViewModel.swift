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
}

//var dummyData = [Dummy(albumName: "일본 여행", startDay: "2023.02.11", endDay: "2023.02.15", withPerson: [.purple, .pink]),
//                 Dummy(albumName: "경주 여행", startDay: "2023.03.30", endDay: "2023.07.16", withPerson: [.purple, .blue, .brown, .cyan, .green]),
//                 Dummy(albumName: "서울 여행", startDay: "2023.07.18", endDay: "2023.07.20", withPerson: [.purple]),
////                 Dummy(albumName: "서울 여행", startDay: "2023.07.13", endDay: "2023.07.14", withPerson: [.purple]),
////                 Dummy(albumName: "서울 여행", startDay: "2023.07.14", endDay: "2023.07.17", withPerson: [.purple]),
////                 Dummy(albumName: "서울 여행", startDay: "2023.07.13", endDay: "2023.07.18", withPerson: [.purple])
//]

var dummyData: [Dummy] = []

let Colors: [Color] = [.brown, .black, .pink, .teal, .yellow, .cyan, .primary]

func hasTraveling() -> Int {
    if !dummyData.isEmpty {
        let day = compareDate(dummyData[dummyData.count-1].startDay, dummyData[dummyData.count-1].endDay)
        return day
    }
    
    return 0
}

func getCurrentDateTime(_ str: inout String) {
    let formatter = DateFormatter() //객체 생성
    formatter.locale = Locale(identifier: "ko_kr")
    formatter.timeZone = TimeZone(abbreviation: "KST")
    formatter.dateStyle = .medium
    formatter.dateFormat = "yyyy.MM.dd" //데이터 포멧 설정
    str = formatter.string(from: Date()) //문자열로 바꾸기
}

func compareDate(_ start: String, _ end: String) -> Int {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_kr")
    formatter.timeZone = TimeZone(abbreviation: "KST")
    formatter.dateStyle = .medium
    formatter.dateFormat = "yyyy.MM.dd"
    
    let startDay = formatter.date(from: start)!
    let endDay = formatter.date(from: end)!
    let current = Date()
    
    if (startDay <= current) && (current <= endDay) {
        // 여행중
        return 1
    } else if current < startDay {
        // 여행전
        return 0
    }
    // 여행 완료
    return 2
}

func travelingDate(_ start: String) -> Int {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_kr")
    formatter.timeZone = TimeZone(abbreviation: "KST")
    formatter.dateStyle = .medium
    formatter.dateFormat = "yyyy.MM.dd"
    
    let startDay = formatter.date(from: start)!
    let day = Int(ceil(Date().timeIntervalSince(startDay) / 86400))
    
    return day
}

func D_Day(_ start: String) -> Int {
    
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_kr")
    formatter.timeZone = TimeZone(abbreviation: "KST")
    formatter.dateStyle = .medium
    formatter.dateFormat = "yyyy.MM.dd"
    
    let startDay = formatter.date(from: start)!
//    let current = Date()
    
    let day = Int(ceil(startDay.timeIntervalSinceNow / 86400))
    
    return day
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

func hasEmpty() -> Bool {
    let value = !dummyData.isEmpty
    
    return value
}
