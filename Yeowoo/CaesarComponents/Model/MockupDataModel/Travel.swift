//
//  Travel.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/17.
//

import Foundation

struct Travel: Identifiable{
    let id = UUID()
    let name: String
    var description: String
    var friendImage: String
    //일단 날짜는 String으로 해둘게요 나중에 Firebase timestamp하실 것 같긴해서
    var Date: String
//    let timestamp: Timestamp
    
    
}

let travels = [
    Travel(name: "제임스", description: "제주도 여행", friendImage: "Azhy", Date: "2023. 04. 23"),
    Travel(name: "제육볶음", description: "일본 여행", friendImage: "Nova", Date: "2023. 01. 05"),
    Travel(name: "Muhammad", description: "Abu Dhabi Trip", friendImage: "Sunday", Date: "2023. 01. 05"),
    Travel(name: "룰루", description: "부산 당일치기", friendImage: "Jigu", Date: "2022. 10. 03"),
    Travel(name: "랄라", description: "스페인 한달살기", friendImage: "Jamie", Date: "2022. 06. 01"),
    Travel(name: "제이미", description: "포항 여행", friendImage: "Noru", Date: "2023. 04. 23"),
    Travel(name: "돈까쓰", description: "북한 여행", friendImage: "Noru", Date: "2023. 04. 23"),
]
