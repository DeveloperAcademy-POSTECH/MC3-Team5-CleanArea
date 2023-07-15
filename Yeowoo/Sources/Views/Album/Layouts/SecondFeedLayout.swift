//
//  ThirdLayout.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/14.
//

import SwiftUI

struct SecondFeedLayout: View {
	
	var entitys: [ImagesEntity]
	
	var body: some View {
		HStack(spacing: 4) {
			VStack(spacing: 4){
				AsyncImage(url: URL(string: entitys[0].url)) { image in
					image
						.resizable()
						.aspectRatio(contentMode: .fill)
						.frame(width: width / 3, height: 123)
						.cornerRadius(4)
				} placeholder: {
					ProgressView()
						.frame(width: width / 3, height: 123)
				}
				if entitys.count >= 2 {
					AsyncImage(url: URL(string: entitys[1].url)) { image in
						image
							.resizable()
							.aspectRatio(contentMode: .fill)
							.frame(width: width / 3, height: 123)
							.cornerRadius(4)
					} placeholder: {
						ProgressView()
							.frame(width: width / 3, height: 123)
					}
				}
			}
			.frame(maxHeight: .infinity, alignment: .top)
			
			VStack(spacing: 4) {
				if entitys.count >= 3 {
					AsyncImage(url: URL(string: entitys[2].url)) { image in
						image
							.resizable()
							.aspectRatio(contentMode: .fill)
							.frame(width: width / 3, height: 123)
							.cornerRadius(4)
					} placeholder: {
						ProgressView()
							.frame(width: width / 3, height: 123)
					}
				}
				if entitys.count >= 4 {
					AsyncImage(url: URL(string: entitys[3].url)) { image in
						image
							.resizable()
							.aspectRatio(contentMode: .fill)
							.frame(width: width / 3, height: 123)
							.cornerRadius(4)
					} placeholder: {
						ProgressView()
							.frame(width: width / 3, height: 123)
					}
				}
			}
			.frame(maxHeight: .infinity, alignment: .top)
			
			if entitys.count >= 5 {
				AsyncImage(url: URL(string: entitys[3].url)) { image in
					image
						.resizable()
						.aspectRatio(contentMode: .fill)
						.frame(width: width / 3, height: 250)
						.cornerRadius(4)
				} placeholder: {
					ProgressView()
						.frame(width: width / 3, height: 250)
				}
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
	}
}
