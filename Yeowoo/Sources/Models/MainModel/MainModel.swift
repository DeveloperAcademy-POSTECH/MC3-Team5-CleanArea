//
//  MainModel.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/20.
//

import SwiftUI

struct Dummy: Identifiable, Hashable {
    var id = UUID()
    var albumName: String
    var startDay: String
    var endDay: String
    var withPerson: [Color]
}

var dummyData = [Dummy(albumName: "일본 여행", startDay: "2023.02.11", endDay: "2023.02.15", withPerson: [.purple, .pink]),
                 Dummy(albumName: "경주 여행", startDay: "2023.03.30", endDay: "2023.07.16", withPerson: [.purple, .blue, .brown, .cyan, .green]),
                 Dummy(albumName: "서울 여행", startDay: "2023.07.18", endDay: "2023.07.20", withPerson: [.purple]),
//                 Dummy(albumName: "서울 여행", startDay: "2023.07.13", endDay: "2023.07.14", withPerson: [.purple]),
//                 Dummy(albumName: "서울 여행", startDay: "2023.07.14", endDay: "2023.07.17", withPerson: [.purple]),
//                 Dummy(albumName: "서울 여행", startDay: "2023.07.13", endDay: "2023.07.18", withPerson: [.purple])
]

//var dummyData: [Dummy] = []

let Colors: [Color] = [.brown, .black, .pink, .teal, .yellow, .cyan, .primary]
