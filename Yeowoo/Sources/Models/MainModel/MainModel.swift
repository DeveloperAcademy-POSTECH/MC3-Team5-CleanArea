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
