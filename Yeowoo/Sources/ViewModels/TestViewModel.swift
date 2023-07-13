//
//  TestViewModel.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/10.
//

import Combine
import Foundation

final class TestViewModel: ObservableObject {
	
	@Published var tests: [Test] = []
	
	private var cancellables = Set<AnyCancellable>()

//	func fetchUser() {
//		print("call fetchUser")
//		FirebaseService.fetchTest()
//			.sink { completion in
//				switch completion {
//				case .failure(let error):
//					print(error.localizedDescription)
//				case.finished:
//					return
//				}
//			} receiveValue: { [weak self] tests in
//				self?.tests = tests
//				print("tests = \(self?.tests ?? [])")
//			}
//			.store(in: &cancellables)
//	}
}
