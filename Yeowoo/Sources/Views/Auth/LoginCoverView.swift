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
			
				VStack(alignment: .center, spacing: 0) {
					Image("loginLogo")
					
					Spacer()
                        .frame(height: UIScreen.getHeight(40))
					
					Image("LoginIamge")
					
					Spacer()
                        .frame(height: UIScreen.getHeight(40))
					
					Button {
						isViewActive = true
					} label: {
						Text("로그인")
                            .font(.custom18semibold())
							.foregroundColor(.white)
                            .frame(width: UIScreen.getWidth(350), height: UIScreen.getHeight(54))
							.background(
								RoundedRectangle(cornerRadius: 10)
									.fill(Color("B1")))
					}
					.navigationDestination(isPresented: $isViewActive, destination: {
						LoginView()
							.navigationBarBackButtonHidden()
					})
					.onReceive(self.appState.$moveToRootView) { moveToDashboard in
						print("logout sibal")
						if moveToDashboard {
							self.isViewActive = false
							self.appState.moveToRootView = false
						}
					}
					
					Spacer()
                        .frame(height: UIScreen.getHeight(12))
					
					NavigationLink(
						destination: SignUpView().navigationBarBackButtonHidden()
					) {
						Text("회원가입")
                            .font(.custom18semibold())
							.foregroundColor(.black)
                            .frame(width: UIScreen.getWidth(350), height: UIScreen.getHeight(54))
							.background(
								RoundedRectangle(cornerRadius: 10)
									.fill(Color("G6")))
					}
					.ignoresSafeArea(.keyboard)
				}
		}
	}
}
