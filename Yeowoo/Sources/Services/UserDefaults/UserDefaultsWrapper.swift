//
//  UserDefaultsWrapper.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/13.
//

import Foundation

@propertyWrapper
struct UserDefaultsWrapper<T> {
	private let key: String
	private let defaultValue: T
	
	init(key: String, defaultValue: T) {
		self.key = key
		self.defaultValue = defaultValue
	}
	
	var wrappedValue: T {
		get {
			return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
		}
		set {
			UserDefaults.standard.set(newValue, forKey: key)
		}
	}
}

