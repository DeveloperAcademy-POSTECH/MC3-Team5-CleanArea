//
//  TimeInterval+.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/19.
//

import Foundation

extension String {
	
	func formatAsDateString() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy. MM. dd"
		return dateFormatter.string(from: Date(timeIntervalSince1970: Double(self) ?? 0.0))
	}
	
	func formatAsTimeString() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.dateFormat = "hh:mm:ss a"
		return dateFormatter.string(from: Date(timeIntervalSince1970: Double(self) ?? 0.0))
	}
}
