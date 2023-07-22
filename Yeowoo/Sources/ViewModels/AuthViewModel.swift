//
//  SignupViewModel.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/21.
//

import Foundation
import Combine

enum IdDuplicateState {
	case none
	case pass
	case duplicate
}

final class AuthViewModel: ObservableObject {
	
	@Published var idDuplicateCheckFlag: IdDuplicateState = .none
	
	private var cancellables = Set<AnyCancellable>()
	
	@MainActor
	func textFieldEditing() {
		idDuplicateCheckFlag = .none
	}
	
	@MainActor
	func idDuplicateCheck(id: String) async throws {
		let check = try await FirebaseService.idDuplicateCheck(id: id)
		idDuplicateCheckFlag = check == .success ? .pass : .duplicate
	}
	
	func signup(id: String, pwd: String, nickname: String) async throws -> Bool {
		let signupUser = User(docId: "", id: id, email: "", password: pwd, isFirstLogin: true,
							  nickname: nickname, profileImage: "", progressAlbum: "", finishedAlbum: [],
							  notification: [], fcmToken: "")
		return try await FirebaseService.signup(user: signupUser) == .success ? true : false
	}
	
	func signin(id: String, pwd: String) async throws -> Bool {
		let chk = try await FirebaseService.signin(loginId: id, password: pwd)
		if chk == .success {
			return true
		} else {
			return false
		}
	}
}
