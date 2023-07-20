//
//  UserDefaultsSetting.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/13.
//

import Foundation

enum UserDefaultsSetting {
	
	@UserDefaultsWrapper(key: "isFirstEnter", defaultValue: true)
	static var isFirstEnter
	
	@UserDefaultsWrapper(key: "userDocId", defaultValue: "")
	static var userDocId
}
