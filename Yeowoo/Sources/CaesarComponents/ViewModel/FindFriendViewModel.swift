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
		_ = try await FirebaseService.createTravel(album: newAlbum)
	}
}
