//
//  NotificationViewModel.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/28.
//

import Combine
import Foundation

final class NotificationViewModel: ObservableObject {
	
	@Published var notifications: [Notification] = []
	
	private var cancellables = Set<AnyCancellable>()
	
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
				self.notifications = noti
				let groupedTravels = Dictionary(grouping: self.notifications, by: { $0.sendDate })
				let sortedGroupedTravels = groupedTravels.sorted(by: { $0.key > $1.key })
			}
			.store(in: &cancellables)
	}
}
