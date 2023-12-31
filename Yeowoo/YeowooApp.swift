//
//  YeowooApp.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/06.
//

import SwiftUI
import FirebaseCore

@main
struct YeowooApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
	
	var body: some Scene {
		WindowGroup {
			// 자동로그인
			if UserDefaultsSetting.userDocId.isEmpty {
				OnboardingView()
			} else {
				let appState = AppState()
				MainView()
					.environmentObject(appState)
			}
		}
	}
}
