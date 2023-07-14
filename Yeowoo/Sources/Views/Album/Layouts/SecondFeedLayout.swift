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
					// 로딩되기 전까지 대체할 이미지 혹은 스타일
				}
				if entitys.count >= 2 {
					AsyncImage(url: URL(string: entitys[1].url)) { image in
						image
							.resizable()
							.aspectRatio(contentMode: .fill)
							.frame(width: width / 3, height: 123)
							.cornerRadius(4)
					} placeholder: {
						// 로딩되기 전까지 대체할 이미지 혹은 스타일
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
						// 로딩되기 전까지 대체할 이미지 혹은 스타일
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
						// 로딩되기 전까지 대체할 이미지 혹은 스타일
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
					// 로딩되기 전까지 대체할 이미지 혹은 스타일
				}
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
	}
}
