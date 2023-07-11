//
//  KeyChainAccount.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/10.
//

import Foundation

enum KeyChainAccount {
	case documentId
	
	var description: String {
		return String(describing: self)
	}
	
	var keyChainClass: CFString {
		switch self {
		case .documentId:
			return kSecClassGenericPassword
		}
	}
}
