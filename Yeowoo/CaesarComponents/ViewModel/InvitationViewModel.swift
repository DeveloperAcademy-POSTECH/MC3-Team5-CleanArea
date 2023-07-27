//
//  InvitationViewModel.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/27.
//

import Combine
import Foundation

// albumId : GQAPDJeFgTtz9V3LeuFe

// 알림 구조
// 보낸 날짜, albumId, 보낸사람 닉네임, 여행 타이틀
// 현재 소속되어있는 userDocId -> 프로필 url 가져오기위함
// + ~ 초대한 여행에 참여할 때 본인 프로필 url 마지막에 추가하기

final class InvitationViewModel: ObservableObject {
	
	private var cancellables = Set<AnyCancellable>()
	
	// 여행에 참가
	func participateTravel(albumDocId: String, role: String) async throws {
		if try await FirebaseService.participateTravel(albumDocId: albumDocId, role: role) == .success { }
	}
}
