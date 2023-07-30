//
//  MainView.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/14.
//

import SwiftUI

// 메인뷰에 세팅
final class AppState: ObservableObject {
	@Published var moveToRootView: Bool = false
}

struct DemoMainView: View {
	@EnvironmentObject var appState: AppState
	@State var isViewActive: Bool = false
	@State var userInfo = User()

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Image("Title")
                        .resizable()
                        .frame(width: 100, height: 40)
                        .padding(.leading, 20)
                        .padding(.top)

                    Spacer()
                    
                    NavigationLink {
                        RoleChangeView()
                            .navigationBarBackButtonHidden()
                    }
                    label : {
                        Image(systemName: "chevron.right.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.unclicked)
                            .opacity(0.2)
                            .overlay(Image(systemName: "chevron.right")
                                .resizable()
                                .frame(width: 8, height: 16))
                            .fontWeight(.bold)
                        .foregroundColor(.mainColor)
                    }
                    .padding(.trailing, 20)
                .padding(.top, 100)
                }
                Spacer()
                HStack {
                    ZStack {RoundedRectangle(cornerRadius: 100)
                            .frame(width: 158, height: 76)
                            .foregroundColor(.whiteGray)
                        HStack{
                            NavigationLink{
                                NotificationView()
                                    .navigationBarBackButtonHidden()
                            } label: {
                                Circle()
                                    .foregroundColor(.white)
                                    .frame(width: 48, height: 48)
                                    .shadow(radius: 20)
                                    .overlay( Image(systemName: "bell.fill")
                                        .foregroundColor(.mainColor))
                            }
                            NavigationLink{
//								SettingView(userInfo: $userInfo)
//                                    .navigationBarBackButtonHidden()
								EmptyView()
									.navigationBarBackButtonHidden()
                            } label: {
                                Circle()
                                    .foregroundColor(.white)
                                    .frame(width: 48, height: 48)
                                    .shadow(radius: 20)
                                    .overlay( Image(systemName: "gear")
                                        .imageScale(.large)
                                        .foregroundColor(.mainColor))
                            }
                        }
                    }
                    .padding(.leading, 20)
                    
                    Spacer()
                    
					Button {
						isViewActive = true
					} label: {
						Image(systemName: "plus.circle.fill")
							.resizable()
							.frame(width: 76, height: 76)
							.foregroundColor(.mainColor)
							.padding(.trailing, 20)
					}
					.navigationDestination(isPresented: $isViewActive, destination: {
						NewAlbumView().navigationBarBackButtonHidden()
					})
					.onReceive(self.appState.$moveToRootView) { moveToDashboard in
						if moveToDashboard {
							print("move pop")
							self.isViewActive = false
							self.appState.moveToRootView = false
						}
					}
                }
            }
			.navigationBarTitle("", displayMode: .automatic)
			.navigationBarHidden(true)
        }
    }
}
