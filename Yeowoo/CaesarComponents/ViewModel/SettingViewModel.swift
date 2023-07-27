//
//  SettingViewModel.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/27.
//

import Foundation
import Combine

final class SettingViewModel: ObservableObject {
	
	private var cancellables = Set<AnyCancellable>()
	
	func withdrawalUser() async throws {
		if try await FirebaseService.withdrawalUser() == .success { }
	}
}
