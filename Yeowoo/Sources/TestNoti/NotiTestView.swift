//
//  NotiTestView.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/20.
//

import SwiftUI

//TravelSampleData 에서 일단 데이터 받아옵니다:)

struct NotiTestView: View {
	//시작 전 여행 네임
	@State var albumName:String = "제주도"
	
	//끝낼 여행 네임
	@State var pastAlbumName:String = "부산"
	
	//받아오는 여행 넘버
	@State var travelNumber:Int = 0
	
	let notify = NotificationHandler()
	
	var body: some View {
		VStack(spacing: 20) {
			Spacer()
			
			//여행 하루전날
			Button("Schedule notification") {
				
				//예약 날짜 - 1일 설정
				var calendar = Calendar.current
				//한국 시간 변환
				calendar.timeZone = TimeZone(abbreviation: "KST")!
				var dateComponents = DateComponents()
				//여기에 데이터 바인딩 넣기
				dateComponents.year = Calendar.current.component(.year, from: schedules[travelNumber].startingDate)
				dateComponents.month = Calendar.current.component(.month, from: schedules[travelNumber].startingDate)
				dateComponents.day = Calendar.current.component(.day, from: schedules[travelNumber].startingDate) - 1
				dateComponents.hour = 13
				let reservedNotificationDate = calendar.date(from: dateComponents) ?? Date()
				
				notify.sendNotification(
					date: reservedNotificationDate,
					type: "date",
					title: "YeoWoo",
					body: "내일⚠️\(albumName)여행을 시작해요! 깜빡하지 마세요!")
				//출력은 미국 시간으로 됩니다 :)
				print(reservedNotificationDate)
				print("내일⚠️\(albumName)여행을 시작해요! 깜빡하지 마세요!")
			}.foregroundColor(.orange)
			Spacer()
			
			//여행 중 하루 3번
			Button("Schedule notification") {
				
				//11시-19시 사이 최소간격 2시간
				var availableHours = Array(stride(from: 11, to: 19, by: 2))
				
				// push 3번
				for _ in 1...3 {
					//
					guard let rndHourIndex = availableHours.indices.randomElement() else { return }
					let rndHour = availableHours[rndHourIndex]
					// 중복 제거
					availableHours.remove(at: rndHourIndex)
					
					// random minute
					let rndMinute = Int.random(in: 0...59)
					
					// manipulate push timer
					var calendar = Calendar.current
					
					var dateComponents = DateComponents()
					//한국 시간 변환
					dateComponents.hour = rndHour - 9
					dateComponents.minute = rndMinute
					let randomNotificationDate = calendar.date(byAdding: dateComponents, to: Date()) ?? Date()
					
					// 랜덤한 push 메시지
					let numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
					let rndPush = numbers.randomElement() ?? 0
					
					notify.sendNotification(
						date: randomNotificationDate,
						type: "date",
						title: "YeoWoo",
						body: pushs[rndPush].content)
					print(randomNotificationDate)
					print(pushs[rndPush].content)
				}
			}.foregroundColor(.yellow)
			
			Spacer()
			
			//여행 후 30일 or 60일 (종료 버튼에 넣기)
			Button("Schedule notification") {
				let numbers = [30, 60]
				let rnd = numbers.randomElement() ?? 30
				
				//여행 종료 버튼에 넣기
				//종료날짜 + rnd일 설정
				var calendar = Calendar.current
				calendar.timeZone = TimeZone(abbreviation: "KST")!
				var dateComponents = DateComponents()
				//여기에 데이터 바인딩 넣기
				dateComponents.year = Calendar.current.component(.year, from: schedules[travelNumber].endingDate)
				dateComponents.month = Calendar.current.component(.month, from: schedules[travelNumber].endingDate)
				dateComponents.day = Calendar.current.component(.day, from: schedules[travelNumber].endingDate)
				//                + rnd
				dateComponents.hour = Calendar.current.component(.hour, from: schedules[travelNumber].endingDate)
				dateComponents.minute = Calendar.current.component(.minute, from: schedules[travelNumber].endingDate)
				let finishedDate = calendar.date(from: dateComponents) ?? Date()
				
				notify.sendNotification(
					date: finishedDate,
					type: "date",
					title: "YeoWoo",
					body: "\(rnd)일 전 \(pastAlbumName)여행을 떠올리면서 오늘도 행복한 하루!🤩")
				
				//출력은 미국 시간으로 됩니다 :)
				print(finishedDate)
				print("\(rnd)일 전 \(pastAlbumName)여행을 떠올리면서 오늘도 행복한 하루!🤩")
			}.foregroundColor(.green)
			
			Spacer()
			
			// 2초 뒤 알림 전송
			Button{
				let center = UNUserNotificationCenter.current()
				
				//create yeowoo content
				let content = UNMutableNotificationContent()
				content.title = "YeoWoo"
				
				print(Text("알람 전송"))
				
				content.body = "testing move to Camera modal"
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
				Text("2초 뒤 알람 전송")
			}
			Spacer()
		}
	}
}

struct NotiTestView_Previews: PreviewProvider {
	static var previews: some View {
		NotiTestView()
	}
}

