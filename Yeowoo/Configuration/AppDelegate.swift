//
//  AppDelegate.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/13.
//

import UIKit
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		
		FirebaseApp.configure()
		
		UNUserNotificationCenter.current().delegate = self
		
		let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
		UNUserNotificationCenter.current().requestAuthorization(
			options: authOptions,
			completionHandler: { _, _ in }
		)
		
		application.registerForRemoteNotifications()
		
		Messaging.messaging().delegate = self
		
		return true
	}
	
	// fcm 토큰이 등록 되었을 때
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		Messaging.messaging().apnsToken = deviceToken
	}
}

extension AppDelegate: MessagingDelegate {
	
	// fcm 등록 토큰을 받았을 때
	func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
		print("get fcmToken \(String(describing: fcmToken))")
		
		FirebaseService.updateFCMToken(fcmToken: fcmToken ?? "")
		
//		if UserDefaultsSetting.isFirstEnter {
//			FirebaseService.updateFCMToken(fcmToken: fcmToken ?? "")
//			UserDefaultsSetting.isFirstEnter = false
//		}
	}
}

extension AppDelegate: UNUserNotificationCenterDelegate {
	
	// foreground
	func userNotificationCenter(_ center: UNUserNotificationCenter,
								willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
		
		let userInfo = notification.request.content.userInfo
		print("willPresent: userInfo ", userInfo)
		return [.banner, .sound, .badge]
	}
	
	// 메시지를 받았을 때
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
		let userInfo = response.notification.request.content.userInfo
		print("didReceive: userInfo ", userInfo)
	}
}
