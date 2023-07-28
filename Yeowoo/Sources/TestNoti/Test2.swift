////
////  ContentView.swift
////  luv-dub Watch App
////
////  Created by 김예림 on 2023/07/12.
////
//
//
//import FirebaseMessaging
//import SwiftUI
//import UserNotifications
//import WatchConnectivity
//
//struct MainPushView: View {
////	@StateObject var viewModelWatch = ViewModelWatch()
//	@StateObject var mainPushViewModel = MainPushViewModel()
//
//	private var notificationData: [String: Any] { [
//		"message": [
//			"token": "viewModelWatch.token",
//			"apns": [
//				"payload": [
//					"aps": [
//						"alert" : [
//							"title" : "Game Request",
//							"subtitle" : "Five Card Draw",
//							"body" : "Bob wants to play poker"
//						],
//						"category" : "hello"
//					],
//				]
//			]
//		]
//	]
//	}
//
//	var body: some View {
////		VStack {
////			Button {
////				mainPushViewModel.pushNotification(notificationData: notificationData)
////				print(viewModelWatch.token)
////			} label: {
////				Circle()
////					.fill(.red)
////					.overlay {
////						Text("SEND")
////					}
////			}
////
////		}
//	}
//}
//
////struct ContentView_Previews: PreviewProvider {
////	static var previews: some View {
////		MainPushView()
////	}
////}
//
////
////  MainPushViewModel.swift
////  luv-dub Watch App
////
////  Created by Song Jihyuk on 2023/07/21.
////
//
//import SwiftUI
//
//struct RefreshToken: Codable {
//	let accessToken: String?
//
//	enum CodingKeys: String, CodingKey {
//		case accessToken = "access_token"
//	}
//}
//
//class MainPushViewModel: ObservableObject {
//	@Published var accessToken = ""
//
//	func pushNotification(notificationData: [String: Any]) {
//		var isRefreshed = false
//		let url = URL(string: "https://fcm.googleapis.com/v1/projects/loveduk-539e3/messages:send")!
//		var request = URLRequest(url: url)
//		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//		request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//		request.httpMethod = "POST"
//
//		let jsonBody = try! JSONSerialization.data(withJSONObject: notificationData, options: [])
//		request.httpBody = jsonBody
//		DispatchQueue.main.async {
//
//		let task = URLSession.shared.dataTask(with: request) { data, response, error in
//			guard let data = data, error == nil else {
//				return
//			}
//
//				if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
//					print("statusCode should be 200, but is \(httpStatus.statusCode)")
//
//					if httpStatus.statusCode == 401 {
//						self.refreshToken()
//						isRefreshed = true
//					}
//				}
//
//				guard isRefreshed else { return }
//				self.pushNotification(notificationData: notificationData)
//			}
//
//			task.resume()
//		}
//
//	}
//
////	func refreshToken() {
////		let urlString = "https://oauth2.googleapis.com/token"
////		guard let url = URL(string: urlString) else {
////			print("Invalid URL")
////			return
////		}
////		let clientID = "757153338890-7mk8qhu88bkjfgcvsctrrachpbudaad9.apps.googleusercontent.com"
////		let clientSecret = "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&refresh_token=1//04JRa2dWY6qfkCgYIARAAGAQSNwF-L9Iru9YVqU7UCYB_Vf1NY6flnXAoMRpwzhL6moG5crZFNQXA8BnbGsxXuJ_DRtaFlbVLz-w"
////		let data = "client_id=\(clientID)&client_secret=\(clientSecret)&grant_type=refresh_token".data(using: .utf8)!
////
////		var request = URLRequest(url: url)
////		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
////		request.httpMethod = "POST"
////		request.httpBody = data
////
////		let task = URLSession.shared.dataTask(with: request) { data, response, error in
////			guard let data = data, error == nil else {
////				return
////			}
////
////			if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
////				print("statusCode should be 200, but is \(httpStatus.statusCode)")
////			}
////
////			do {
////				let decoder = JSONDecoder()
////				let jsonData = try decoder.decode(RefreshToken.self, from: data)
////				if let accessToken = jsonData.accessToken {
////					self.accessToken = accessToken
////					print(accessToken)
////				}
////
////			} catch {
////				print(error)
////			}
////		}
////		task.resume()
////	}
//}
