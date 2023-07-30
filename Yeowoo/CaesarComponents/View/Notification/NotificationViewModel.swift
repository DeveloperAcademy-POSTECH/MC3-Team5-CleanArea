//
//  NotificationViewModel.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/28.
//

import Combine
import Foundation

// albumId : GQAPDJeFgTtz9V3LeuFe

// 알림 구조
// 보낸 날짜, albumId, 보낸사람 닉네임, 여행 타이틀
// 현재 소속되어있는 userDocId -> 프로필 url 가져오기위함
// + ~ 초대한 여행에 참여할 때 본인 프로필 url 마지막에 추가하기

final class NotificationViewModel: ObservableObject {
	
	@Published var notis: [Notification] = []
	
	private var cancellables = Set<AnyCancellable>()
	
	// 여행에 참가
	
	func fetchNotification() {
		FirebaseService.fetchNotification()
			.sink { completion in
				switch completion {
				case .failure(let error):
					print(error.localizedDescription)
				case .finished:
					return
				}
			} receiveValue: { noti in
//				self.users = user
				self.notis = noti
				print("@@ noti \(noti)")
				let groupedTravels = Dictionary(grouping: self.notis, by: { $0.sendDate })
				let sortedGroupedTravels = groupedTravels.sorted(by: { $0.key > $1.key })
				print("@@ groupedTravels \(groupedTravels)")
				print("@@ sortedGroupedTravels \(sortedGroupedTravels)")
			}
			.store(in: &cancellables)
	}
}
