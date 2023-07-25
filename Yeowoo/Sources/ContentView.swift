//
//  ContentView.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/06.
//

import SwiftUI
import UIKit

struct ContentView: View {
	
	@ObservedObject var viewModel = AlbumViewModel()
	
	init() {
		UINavigationBar.appearance().backgroundColor = .white
	}

	var body: some View {
		NavigationView {
			NavigationLink("테스트") {
				AlbumFeedView(albumDocId: "T9eJMPQEGQClFHEahX6r", viewModel: viewModel)
					.navigationBarTitle("")
					.navigationBarHidden(true)
			}
			.navigationTitle("")
		}
		.accentColor(Color("G4"))
	}
}
