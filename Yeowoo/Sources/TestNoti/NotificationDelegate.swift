//
//  PushTestView.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/19.
//

import SwiftUI

enum NotificationAction: String {
	case dismiss
	case reminder
}

enum NotificationCategory: String {
	case general
}
//
//class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//
//        let userInfo = response.notification.request.content.userInfo
//        print(userInfo)
//        //바로 카메라로 가도록?
//
//        completionHandler()
//    }
//
//    //Can use yeowoo app in foreground states
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.banner, .sound, .badge])
//    }
//
//
//}

struct PushTestView: View {
	
	@State var albumName:String = "제주도"
	
	var body: some View {
		VStack{
			
			Spacer()
			
			Button{
				
				let center = UNUserNotificationCenter.current()
				
				//create yeowoo content
				let content = UNMutableNotificationContent()
				content.title = "YeoWoo"
				
				print(Text("⚠️\(albumName)여행을 시작해요! 깜빡하지 마세요!"))
				
				content.body = "⚠️\(albumName)여행을 시작해요! 깜빡하지 마세요!"
				content.categoryIdentifier = NotificationCategory.general.rawValue
				//위에 userNotificaitonCenter didReceive func Check 용도
				content.userInfo = ["먹방여우": "핀"]
				
				//create trigger(시간 랜덤? 예정) 지금은 버튼 누르고 5초 뒤
				let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2.0, repeats: false)
				
				
				//create request
				let request = UNNotificationRequest(identifier: "Identifier", content: content, trigger: trigger)
				
				//define actions
				let dismiss = UNNotificationAction(identifier: NotificationAction.dismiss.rawValue, title: "Dismiss")
				
				let reminder = UNNotificationAction(identifier: NotificationAction.reminder.rawValue, title: "Reminder")
				
				let generalCategory = UNNotificationCategory(identifier: NotificationCategory.general.rawValue, actions: [reminder, dismiss], intentIdentifiers: [])
				
				center.setNotificationCategories([generalCategory])
				
				//add request to notification center
				center.add(request) { error in
					if let error = error {
						print(error)
					}
				}
				
				

			} label: {
				Text("여행 시작 하루 전(traveling = 0)")
			}
			
			Spacer()
			
			Button{
				
				let center = UNUserNotificationCenter.current()
				
				//create yeowoo content
				let content = UNMutableNotificationContent()
				content.title = "YeoWoo"
				
				let numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
				let rnd = numbers.randomElement() ?? 0
				print(pushs[rnd].content)
				
				content.body = pushs[rnd].content
				content.categoryIdentifier = NotificationCategory.general.rawValue
				//위에 userNotificaitonCenter didReceive func Check 용도
				content.userInfo = ["먹방여우": "핀"]
				
				//create trigger(시간 랜덤? 예정) 지금은 버튼 누르고 5초 뒤
				let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2.0, repeats: false)
				
				
				//create request
				let request = UNNotificationRequest(identifier: "Identifier", content: content, trigger: trigger)
				
				//define actions
				let dismiss = UNNotificationAction(identifier: NotificationAction.dismiss.rawValue, title: "Dismiss")
				
				let reminder = UNNotificationAction(identifier: NotificationAction.reminder.rawValue, title: "Reminder")
				
				let generalCategory = UNNotificationCategory(identifier: NotificationCategory.general.rawValue, actions: [reminder, dismiss], intentIdentifiers: [])
				
				center.setNotificationCategories([generalCategory])
				
				//add request to notification center
				center.add(request) { error in
					if let error = error {
						print(error)
					}
				}
				
				

			} label: {
				Text("여행 중(traveling = 1)")
			}
			
			Spacer()
			
			Button{
				
				let center = UNUserNotificationCenter.current()
				
				//create yeowoo content
				let content = UNMutableNotificationContent()
				content.title = "YeoWoo"
				
				let numbers = [30, 40, 50]
				let rnd = numbers.randomElement() ?? 30
				print(Text("\(rnd)일 전의 여행을 떠올리면서 오늘도 행복한 하루!🤩"))
				
				content.body = "\(rnd)일 전의 여행을 떠올리면서 오늘도 행복한 하루!🤩"
				content.categoryIdentifier = NotificationCategory.general.rawValue
				//위에 userNotificaitonCenter didReceive func Check 용도
				content.userInfo = ["먹방여우": "핀"]
				
				
				//찍은 사진 데이터(가능하면?)
				if let url = Bundle.main.url(forResource: "1", withExtension: "png") {
					if let attachment = try? UNNotificationAttachment(identifier: "image", url: url) {
						content.attachments = [attachment]
					}
				}
				
				
				
				//create trigger(시간 랜덤? 예정) 지금은 버튼 누르고 2초 뒤
				let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2.0, repeats: false)
				
				
				//create request
				let request = UNNotificationRequest(identifier: "Identifier", content: content, trigger: trigger)
				
				//define actions
				let dismiss = UNNotificationAction(identifier: NotificationAction.dismiss.rawValue, title: "Dismiss")
				
				let reminder = UNNotificationAction(identifier: NotificationAction.reminder.rawValue, title: "Reminder")
				
				let generalCategory = UNNotificationCategory(identifier: NotificationCategory.general.rawValue, actions: [reminder, dismiss], intentIdentifiers: [])
				
				center.setNotificationCategories([generalCategory])
				
				//add request to notification center
				center.add(request) { error in
					if let error = error {
						print(error)
					}
				}
				
				

			} label: {
				Text("여행 후 30, 40, 50 랜덤 보내기 (traveling = 2)")
			}
			
			Spacer()

			
		}
	}
}

struct PushTestView_Previews: PreviewProvider {
	static var previews: some View {
		PushTestView()
	}
}
