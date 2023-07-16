//
//  ContentView.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/06.
//

import SwiftUI

struct ContentView: View {
	var body: some View {
		NavigationView {
			NavigationLink("테스트") {
				AlbumView(albumDocId: "T9eJMPQEGQClFHEahX6r")
					.navigationBarTitle("타이틀")
					.navigationBarItems(
						trailing:
							Menu {
								Button {
									print("앨범 제목 수정하기")
								} label: {
									Label("앨범 제목 수정하기", systemImage: "pencil")
								}
								Button(role: .destructive) {
									print("여행 종료하기")
								} label: {
									Label("여행 종료하기", systemImage: "xmark.circle")
								}
							}
						label: {
							Image(systemName: "plus")
						}
					)
			}
			.navigationTitle("")
		}
	}
}
