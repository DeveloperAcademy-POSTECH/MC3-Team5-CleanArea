//
//  LoginCoverView.swift
//  Yeowoo
//
//  Created by Jisu Lee on 2023/07/16.
//

import SwiftUI

func sendPushNotification(to token: [String], title: String, body: String) {
	let servertoken = "AAAA4KO-MwQ:APA91bEIXXh04n3m6Kh7lBDkPz8fLkquU6XKvmbdPQRIFN65v8tCbANrSL5ogt6IY9a9pKXa2lhQcMI_K4IKexExQ2KsERemlwmG__tXZ3870yoCje-_9r5z9EYAO7EzJbhAgNTJ7xGm"
	let urlString = "https://fcm.googleapis.com/fcm/send"
	let url = NSURL(string: urlString)!
	token.forEach { tokenVal in
		let stringToken = String(describing: tokenVal)
		let paramString: [String : Any] = ["to" : stringToken,
										   "notification" : ["title" : title, "body" : body],
										   "data" : ["user" : "test_id"]
		]
		let request = NSMutableURLRequest(url: url as URL)
		request.httpMethod = "POST"
		request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.setValue("key=\(servertoken)", forHTTPHeaderField: "Authorization")
		let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
			do {
				if let jsonData = data {
					if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
						NSLog("Received data:\n\(jsonDataDict))")
					}
				}
			} catch let err as NSError {
				print(err.debugDescription)
			}
		}
		task.resume()
	}
}


struct LoginCoverView: View {

	@EnvironmentObject var appState: AppState
	@State var isViewActive: Bool = false
	@State var userInfo = User()
	
	var body: some View {
		NavigationStack {
			ZStack {
				VStack(alignment: .center, spacing: 0) {
					Image("loginLogo")
				}
				
				Button {
					isViewActive = true
				} label: {
					Text("로그인")
						.font(.system(size: 18))
						.fontWeight(.semibold)
						.foregroundColor(.white)
						.frame(width: 350, height: 54)
						.background(
							RoundedRectangle(cornerRadius: 10)
								.fill(Color("B1")))
				}
				.navigationDestination(isPresented: $isViewActive, destination: {
					SettingView(userInfo: $userInfo)
				})
				.onReceive(self.appState.$moveToRootView) { moveToDashboard in
					if moveToDashboard {
						self.isViewActive = false
						self.appState.moveToRootView = false
					}
				}
				.padding(.top, 320)
				
				NavigationLink(destination: SignUpView()) {
					Text("회원가입")
						.font(.system(size: 18))
						.fontWeight(.semibold)
						.foregroundColor(.black)
						.frame(width: 350, height: 54)
						.background(
							RoundedRectangle(cornerRadius: 10)
								.fill(Color("G6")))
				}
				.ignoresSafeArea(.keyboard)
				.padding(.top, 440)
			}
		}
		.onAppear {
//			sendPushNotification(to: "cBQ7l9axn0q7gb3AYab9jf:APA91bGZ3xRKQVgGI5V084qArYZKXON8ypDx_jBqbpNXpQPxgCbJlM-MH3uEZ1eR5LBjyhB063ofEY0QBdpDIgm1k2NY8AcSCx1ZBnc24-xRKDxt0Qz_9GBaWD5H4dftIiBW5bCKU-Zw", title: "title", body: "제발 바디")
		}
	}
}
