////
////  NotifcationCardView.swift
////  YeoWooSimpleView
////
////  Created by 정회승 on 2023/07/14.
////
//
//import SwiftUI
//
//struct NotiCardView: View {
//	@State var dayNotiNum: Int = 1
//
//	//    let travels : [Travel]
//	//	let notis: [Notification]
//	var sortedGroupedTravels: [(key: String, value: [Notification])]
//
//	var body: some View {
//		//        VStack {
//		//			Text(notis.first?.sendDate ?? "None")
//		//                .font(.system(size: 18, weight: .semibold, design: .default))
//		//                .frame(maxWidth: .infinity, alignment: .leading)
//		//                .padding(.leading, 20)
//		//                .padding(.bottom, 20)
//		//
//		//			ForEach(Array(notis.enumerated()), id: \.element.albumId) { index, travel in
//		//                NotiCardContentsView(notis: notis[index])
//		//
//		//                // Check if current item is not the last one
//		//                if index != travels.count - 1 {
//		//                    Divider()
//		//                        .frame(width: UIScreen.width - 50)
//		//                }
//		//            }
//		//        }
//		//        .padding(.bottom, 49)
//
//
//		VStack {
//			ForEach(sortedGroupedTravels, id: \.key) { date, notisForDate in
//				Text(date)
//					.font(.system(size: 18, weight: .semibold, design: .default))
//					.frame(maxWidth: .infinity, alignment: .leading)
//					.padding(.leading, 20)
//					.padding(.bottom, 20)
//
//				ForEach(notisForDate, id: \.albumId) { noti in
//					NotiCardContentsView(notis: [noti])
//				}
//
//				Divider()
//			}
//		}
//		.padding(.bottom, 49)
//		//		.modifier(CardViewModifier(height: CGFloat(65 * dayNotiNum)))
//	}
//}

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
