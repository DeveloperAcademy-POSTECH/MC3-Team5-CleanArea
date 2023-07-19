//
//  AlbumDetailView.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/16.
//

import SwiftUI

struct AlbumDetailView: View {
	
	var entitys: ImagesEntity
	var user: User
	
	var body: some View {
		VStack(alignment: .leading) {
			HStack() {
				AsyncImage(url: URL(string: user.profileImage)) { image in
					image
						.resizable()
						.frame(width: 32, height: 32)
						.clipShape(Circle())
				} placeholder: {
					ProgressView()
						.frame(width: 32, height: 32)
				}
				Text(user.nickname)
				Spacer()
			}
			.padding(.horizontal, 20)
			AsyncImage(url: URL(string: entitys.url)) { image in
				image
					.resizable()
					.frame(height: 500)
					.cornerRadius(20)
					.overlay {
						HStack(alignment: .bottom) {
							Divider().opacity(0)
							Spacer()
							VStack {
								Circle()
									.fill(Color.white)
									.opacity(0.25)
									.frame(width: 48, height: 48)
									.overlay {
										Image(systemName: "heart.fill")
											.foregroundColor(Color.white)
									}
								Rectangle()
									.fill(Color.white)
									.opacity(0.25)
									.frame(width: 48, height: 24)
									.cornerRadius(100)
									.overlay {
										//									Text("\(entitys[index].like)")
										Text("\(entitys.like)")
											.font(.system(size: 16, weight: .medium))
											.foregroundColor(Color.white)
									}
							}
						}
						.padding(.horizontal)
						.padding(.bottom, 20)
					}
			} placeholder: {
				ProgressView()
					.frame(width: UIScreen.main.bounds.width, height: 500)
			}
			.padding(.horizontal, 4)
			Text(entitys.comment)
				.font(.system(size: 14))
				.foregroundColor(Color.black)
				.padding(.horizontal, 20)
			Spacer()
		}
	}
}

//struct AlbumDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        AlbumDetailView()
//    }
//}
