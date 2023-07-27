//
//  TravelSampleData.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/21.
//

import SwiftUI

struct Schedule: Identifiable {
	let id = UUID()
	var startingDate: Date
	var endingDate: Date
}

let schedules = [
	Schedule(startingDate: Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 22))!,
			 endingDate: Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 23, hour: 17, minute: 9))!),
	Schedule(startingDate: Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 25))!,
			 endingDate: Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 26, hour: 15, minute: 30))!),
]

