//
//  KeyChainError.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/10.
//

import Foundation

enum KeyChainError: LocalizedError {
	case unhandledError(status: OSStatus)
	case itemNotFound
	
	var errorDescription: String? {
		switch self {
		case .unhandledError(let status):
			return "KeyChain unhandle Error: \(status)"
		case .itemNotFound:
			return "KeyChain item Not Found"
		}
	}
}
