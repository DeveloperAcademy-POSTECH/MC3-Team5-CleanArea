//
//  TestView.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/10.
//

import SwiftUI

struct TestView: View {
	
	@EnvironmentObject var testViewModel: TestViewModel

	var body: some View {
		VStack {
			Image(systemName: "globe")
				.imageScale(.large)
				.foregroundColor(.accentColor)
			Button {
				print("fetchUser click")
				testViewModel.fetchUser()
			} label: {
				Text(testViewModel.tests.first?.nickname ?? "닉네임 없음")
			}
		}
		.padding()
	}
}
