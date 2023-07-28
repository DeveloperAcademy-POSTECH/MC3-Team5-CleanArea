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
//			if UserDefaultsSetting.userDocId.isEmpty {
//				LoginCoverView()
//			} else {
//				MainView()
//			}
			
			
			MainView()
			
			// Test
//			LoginCoverView()
			
//			NotificationView()
			
			// CameraButtonView()
			//			 MainView()
			// SignUpView()
			//			NewAlbumView()
			
//						let appState = AppState()
//			//
//						DemoMainView()
//							.environmentObject(appState)
			
			//			MainView()
			
			//			ContentView()
		}
	}
}
