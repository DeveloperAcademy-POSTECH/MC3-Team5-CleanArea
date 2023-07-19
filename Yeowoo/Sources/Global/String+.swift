//
//  TimeInterval+.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/19.
//

import Foundation

extension String {
	func formatAsTimeString() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "hh:mm:ss a"
		return dateFormatter.string(from: Date(timeIntervalSince1970: Double(self) ?? 0.0))
	}
}
