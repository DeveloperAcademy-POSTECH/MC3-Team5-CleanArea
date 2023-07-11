//
//  KeyChainManager.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/10.
//

import Foundation
import Security

final class KeyChainManager {
	
	static let shared = KeyChainManager()
	static let serviceName = "yeowoo"
	
	private init() { }
	
	func create(account: KeyChainAccount, documentId: String) throws {
		let query = [
			kSecClass: account.keyChainClass,
			kSecAttrService: KeyChainManager.serviceName,
			kSecAttrAccount: account.description,
			kSecValueData: (documentId as AnyObject).data(using: String.Encoding.utf8.rawValue) as Any
		] as CFDictionary
		
		SecItemDelete(query as CFDictionary)
		
		let status = SecItemAdd(query as CFDictionary, nil)
		
		guard status == noErr else {
			throw KeyChainError.unhandledError(status: status)
		}
	}
	
	func read(account: KeyChainAccount) throws -> String {
		let query = [
			kSecClass: account.keyChainClass,
			kSecAttrService: KeyChainManager.serviceName,
			kSecAttrAccount: account.description,
			kSecReturnData: true
		] as [CFString : Any] as CFDictionary
		
		var dataTypeRef: AnyObject?
		let status = SecItemCopyMatching(query, &dataTypeRef)
		
		guard status != errSecItemNotFound else {
			throw KeyChainError.itemNotFound
		}
		
		if status == errSecSuccess,
		   let item = dataTypeRef as? Data,
		   let data = String(data: item, encoding: String.Encoding.utf8) {
			return data
		} else {
			throw KeyChainError.unhandledError(status: status)
		}
	}
	
	func delete(account: KeyChainAccount) throws {
		let query = [
			kSecClass: account.keyChainClass,
			kSecAttrService: KeyChainManager.serviceName,
			kSecAttrAccount: account.description
		] as [CFString : Any] as CFDictionary
		
		let status = SecItemDelete(query)
		
		guard status == errSecSuccess || status == errSecItemNotFound else {
			throw KeyChainError.unhandledError(status: status)
		}
	}
}

