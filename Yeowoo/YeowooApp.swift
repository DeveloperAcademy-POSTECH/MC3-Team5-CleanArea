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
//            ContentView()
//			TestView()
//				.environmentObject(TestViewModel())
//            LoginCoverView()
//            CameraButtonView()
//            MainView()
			DemoMainView()
        }
    }
}
