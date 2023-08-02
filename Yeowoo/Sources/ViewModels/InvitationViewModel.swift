//
//  InvitationViewModel.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/27.
//

import Foundation

final class InvitationViewModel: ObservableObject {
	
	func participateTravel(albumDocId: String, role: String, noti: Notification) async throws {
		if try await FirebaseService.participateTravel(albumDocId: albumDocId,
													   role: role, notification: noti) == .success { }
	}
}
