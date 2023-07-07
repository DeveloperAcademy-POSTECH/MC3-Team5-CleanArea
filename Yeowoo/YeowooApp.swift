//
//  YeowooApp.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/06.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
				   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
	FirebaseApp.configure()

	return true
  }
}

@main
struct YeowooApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
	
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
