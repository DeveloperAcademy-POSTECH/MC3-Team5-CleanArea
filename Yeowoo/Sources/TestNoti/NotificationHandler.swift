//
//  NotificationHandler.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/20.
//

import SwiftUI
import UserNotifications


class NotificationHandler {
	
	//여행 날짜 컴포넌트
	func sendNotification(date: Date, type: String, timeInterval: Double = 10, title: String, body: String) {
		var trigger: UNNotificationTrigger?
		
		if type == "date" {
			let dateComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date)
			trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
		} else if type == "time" {
			trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
		}
		
		let content = UNMutableNotificationContent()
		content.title = title
		content.body = body
		content.sound = UNNotificationSound.default
		
		let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
		
		UNUserNotificationCenter.current().add(request)
		
	}
	
}



class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		
		let userInfo = response.notification.request.content.userInfo
		print(userInfo)
		//바로 카메라로 가도록?
		
		
		completionHandler()
	}
	
	//Can use yeowoo app in foreground states
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler([.banner, .sound, .badge])
	}
	
	
}




