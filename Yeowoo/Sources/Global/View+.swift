//
//  View+.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/22.
//

import SwiftUI

extension View {
	func endTextEditing() {
		UIApplication.shared.sendAction(
			#selector(UIResponder.resignFirstResponder),
			to: nil, from: nil, for: nil)
	}
}
