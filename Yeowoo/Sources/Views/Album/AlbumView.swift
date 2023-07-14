//
//  AlbumView.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/14.
//

import SwiftUI

struct AlbumView: View {
	
	@State var toggleOn = false
	@StateObject var viewModel = AlbumViewModel()
	
	var body: some View {
		ScrollView {
			VStack {
				ScrollView(.horizontal) {
					HStack {
						// db에서 이 앨범에 있는 유저 수만큼
						ForEach(0..<6) { _ in
							VStack {
								Rectangle()
									.fill(Color.purple)
									.cornerRadius(20)
									.overlay {
										// 여우 이미지
									}
									.frame(width: 70, height: 84)
								Text("건축가 여우")
									.font(.system(size: 12))
									.fontWeight(.bold)
								Text("노루궁뎅이버섯")
									.font(.system(size: 12))
							}
						}
					}
				}
				.padding(.leading, 20)
				.padding(.trailing, 20)
				
				LazyVStack(pinnedViews: [.sectionHeaders]){
					Section {
						VStack(spacing: 4) {
							ForEach(viewModel.images.indices, id: \.self) { index in
								if toggleOn {
									if index % 3 == 1 {
										FirstFeedLayout(entitys: viewModel.images[index])
									} else {
										SecondFeedLayout(entitys: viewModel.images[index])
									}
								} else {
									GalleryLayout(entitys: viewModel.images[index])
								}
							}
						}
					} header: {
						HStack {
							Toggle(isOn: self.$toggleOn) {
								Text("All")
							}
							.padding(.horizontal)
						}
						.frame(height: 40)
						.background(Color.white)
					}
				}
			}
		}
		.onAppear {
//			viewModel.fetchAlbumImages(albumDocId: "")
		}
	}
}

//struct AlbumView_Previews: PreviewProvider {
//	static var previews: some View {
//		AlbumView()
//	}
//}
