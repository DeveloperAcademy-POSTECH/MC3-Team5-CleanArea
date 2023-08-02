//
//  SettingViewModel.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/27.
//

import Foundation
import UIKit

final class SettingViewModel: ObservableObject {
	
	@Published var idDuplicateCheckFlag: IdDuplicateState = .none
	@Published var users: [User] = []
	
	@MainActor
	func idDuplicateCheck(id: String) async throws {
		let check = try await FirebaseService.idDuplicateCheck(id: id)
		idDuplicateCheckFlag = check == .success ? .pass : .duplicate
	}
	
	@MainActor
	func textFieldEditing() {
		idDuplicateCheckFlag = .none
	}
	
	func withdrawalUser() async throws {
		if try await FirebaseService.withdrawalUser() == .success { }
	}
	
	func updateProfile(imageData: Data? = nil, nickName: String, id: String) async throws {
		if imageData == nil {
			if try await FirebaseService.updateProfile(nickname: nickName,
													   id: id) == .success { }
		} else {
			if try await FirebaseService.updateProfile(image: UIImage(data: imageData!)!,
													   nickname: nickName,
													   id: id) == .success { }
		}
	}
}
