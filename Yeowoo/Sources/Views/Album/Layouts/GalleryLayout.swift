//
//  AlbumGalleryView.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/14.
//

import SwiftUI

struct GalleryLayout: View {
	
	var entitys: [ImagesEntity]
	
	var body: some View {
		ForEach(entitys.indices, id: \.self) { index in
			AsyncImage(url: URL(string: entitys[index].url)) { image in
				image
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(width: UIScreen.main.bounds.width, height: 390)
					.cornerRadius(4)
					.overlay {
						HStack(alignment: .bottom) {
							Divider().opacity(0)
							Text("\(entitys[index].comment)")
								.font(.system(size: 14))
							Spacer()
							VStack {
								Circle()
									.fill(Color.white)
									.opacity(0.25)
									.frame(width: 48, height: 48)
									.overlay {
										Image(systemName: "heart.fill")
									}
								Rectangle()
									.fill(Color.white)
									.opacity(0.25)
									.frame(width: 48, height: 24)
									.cornerRadius(100)
									.overlay {
										Text("\(entitys[index].like)")
											.font(.system(size: 16, weight: .medium))
									}
							}
						}
						.padding(.horizontal)
						.padding(.bottom, 20)
					}
			} placeholder: {
				ProgressView()
					.frame(width: UIScreen.main.bounds.width, height: 390)
			}
		}
	}
	
}
