//
//  InvitationView.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/19.
//

import SwiftUI

struct InvitationView: View {
	
	@StateObject var mainViewModel: MainViewModel
	
	let notification : Notification
	let users: [User]
	
	var body: some View {
		if notification.userDocIds.count < 3 {
			TwoInvitationView(mainViewModel: mainViewModel, noti: notification, users: users)
		} else {
			MultiInvitationView(mainViewModel: mainViewModel, noti: notification, users: users)
		}
	}
}
