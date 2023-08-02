//
//  NotifcationCardView.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/14.
//

import SwiftUI

struct NotiCardView: View {
	
	@StateObject var mainViewModel: MainViewModel
	
	var sortedGroupedTravels: [(key: String, value: [Notification])]
	
	var body: some View {
		VStack {
			ForEach(sortedGroupedTravels, id: \.key) { item in
				Text(item.key)
					.font(.system(size: 18, weight: .semibold, design: .default))
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.leading, 20)
					.padding(.bottom, 20)
				
				ForEach(item.value, id: \.albumId) { noti in
					NotiCardContentsView(notis: noti, mainViewModel: mainViewModel)
				}
				Divider()
			}
		}
		.padding(.bottom, 49)
	}
}
