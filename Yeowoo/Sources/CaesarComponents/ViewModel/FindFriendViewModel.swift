//
//  FindFriendViewModel.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/24.
//

import Foundation
import Combine

enum SearchState {
	case none
	case success
	case fail
}

final class FindFriendViewModel: ObservableObject {
		
	private var cancellables = Set<AnyCancellable>()

	/// 검색한 유저 찾기
	@MainActor
	func searchUser(parmUserId: String) async throws -> User {
		return try await FirebaseService.searchUser(userId: parmUserId)
	}
	
	/// 여행 생성
	@MainActor
	func createTravel(newAlbum: Album) async throws -> Void {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy.MM.dd"
		let notification = Notification(albumId: newAlbum.id,
										sendDate: dateFormatter.string(from: Date()),
										sendUserNickname: UserDefaultsSetting.nickname,
										travelTitle: newAlbum.albumTitle,
										userDocIds: newAlbum.users,
										isParticipateChk: false)
		_ = try await FirebaseService.createTravel(album: newAlbum, notification: notification)
	}
	
	func inviteFriend(album: Album) async throws -> Void {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy.MM.dd"
		let notification = Notification(albumId: album.id,
										sendDate: dateFormatter.string(from: Date()),
										sendUserNickname: UserDefaultsSetting.nickname,
										travelTitle: album.albumTitle,
										userDocIds: album.users,
										isParticipateChk: false)
		_ = try await FirebaseService.inviteFriend(album: album, notification: notification)
	}
}
