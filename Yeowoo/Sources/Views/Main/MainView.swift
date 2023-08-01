//
//  MainView.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/17.
//

import SwiftUI

final class AppState: ObservableObject {
	@Published var moveToRootView: Bool = false
}

struct MainView: View {
	@EnvironmentObject var appState: AppState
	@ObservedObject var mainViewModel = MainViewModel()
	@ObservedObject var albumViewModel = AlbumViewModel()
	
	@State var isViewActive = false
	
	var body: some View {
		NavigationView {
			ZStack {
				VStack {
					HStack {
						Spacer()
							.frame(width: UIScreen.getWidth(20))
						
						Image("Title")
							.resizable()
							.frame(width: UIScreen.getWidth(61), height: UIScreen.getHeight(27))
							.padding(.top, 5)
						
						Spacer()
						
						// Alarm, Setting 버튼
						HStack {
							NavigationLink(destination:
											NotificationView(mainViewModel: mainViewModel).navigationBarBackButtonHidden()
										   , isActive: $mainViewModel.openAlarm) {
								Button(action: {
									mainViewModel.openAlarm.toggle()
									mainViewModel.hasAlarm = false
								}) {
									ZStack {
										Image(mainViewModel.hasAlarm == true ? "AlarmBell" : "Bell")
											.resizable()
											.aspectRatio(contentMode: .fit)
											.frame(width: UIScreen.getWidth(28), height: UIScreen.getHeight(29))
									}
								}
							}
							
							
							Spacer()
								.frame(width: UIScreen.getWidth(9))
							
							
                            NavigationLink(destination: SettingView(mainViewModel: mainViewModel, userInfo: mainViewModel.users.first ?? User()).navigationBarBackButtonHidden(), isActive: $mainViewModel.openSetting) {
                                Button(action: {
                                    mainViewModel.openSetting.toggle()
                                }) {
                                    ZStack {
                                        Image("Person")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: UIScreen.getWidth(24))
                                    }.frame(width: UIScreen.getWidth(27), height: UIScreen.getHeight(29))
                                }
                            }
						}
							
						Spacer()
							.frame(width: UIScreen.getWidth(20))
					}
					.padding(.top, 30)
					.frame(height: UIScreen.getHeight(25))
					
					Spacer()
						.frame(height: UIScreen.getHeight(mainViewModel.hasAlbum == 2 ? 35 : 84))
					
					// 메인
					ZStack {
						if mainViewModel.hasAlbum == 2 {
							ScrollView(.vertical, showsIndicators: true, content: {
								VStack(spacing: 0) {
									if !(mainViewModel.traveling == 2) {
										if mainViewModel.traveling == 1 {
											// 친구들과 단체 사진 어떠세요?
											RecommendLayout(role: $mainViewModel.role,
															startday: mainViewModel.albums[0].startDay,
															nickname: mainViewModel.users[0].nickname)
										} else {
											// 여행까지 며칠 남았어요!
											BeforeTravelLayout(role: $mainViewModel.role,
															   nickname: mainViewModel.users[0].nickname,
															   startDay: mainViewModel.albums[0].startDay)
										}
										
										NavigationLink(destination:
											AlbumFeedView(mainViewModel: mainViewModel, albumDocId: mainViewModel.albums[0].id, viewModel: AlbumViewModel())
												.navigationBarBackButtonHidden()
                                                       , isActive: $mainViewModel.openAlbum) {
											// ViewModel에 userProfileImage 가져오는 메소드 추가
                                            Button(action: {
                                                mainViewModel.openAlbum.toggle()
                                            }) {
                                                ZStack {
                                                    LinearGradient(gradient: Gradient(colors: [.clear, Color("G5")]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                                                    VStack(spacing: 0) {
                                                        Spacer()
                                                            .frame(height: UIScreen.getHeight(24))
                                                        AlbumLayout(
                                                            coverImage: mainViewModel.albums[0].albumCoverImage,
                                                            userId: mainViewModel.albums[0].users,
                                                            travelName: mainViewModel.albums[0].albumTitle,
                                                            startDay: mainViewModel.albums[0].startDay,
                                                            endDay: mainViewModel.albums[0].endDay)
                                                        Spacer()
                                                            .frame(height: UIScreen.getHeight(24))
                                                    }
                                                }
                                            }
										}
										
										Spacer()
											.frame(height: UIScreen.getHeight(24))
									} else if mainViewModel.albums[0].endDay == mainViewModel.today {
										
										ZStack {
											LinearGradient(gradient: Gradient(colors: [.clear, Color("G5")]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
											
											DoneTravelLayout(userNames: mainViewModel.albums[0].users,
															 images: mainViewModel.albums[0].images,
															 nickname: mainViewModel.users[0].nickname,
															 albumName: mainViewModel.albums[0].albumTitle)
										}
										
										Spacer()
											.frame(height: UIScreen.getHeight(24))
									} else {
										VStack {
											Spacer()
												.frame(height: UIScreen.getHeight(24))
										}
									}
                                    if (mainViewModel.albums.count == 1 && mainViewModel.albums[0].endDay == mainViewModel.today) ||
                                        mainViewModel.albums.count > 1 {
                                        VStack {
                                            HStack {
                                                Spacer()
                                                    .frame(width: UIScreen.getWidth(20))
                                                
                                                Text("우리가 함께한 추억들")
                                                    .font(.custom18bold())
                                                
                                                Spacer()
                                            }
                                            Spacer()
                                                .frame(height: UIScreen.getHeight(24))
                                        }
                                    }
									
									ForEach(mainViewModel.albums[((mainViewModel.traveling == 1 || mainViewModel.traveling == 0) ? 1 : 0)..<mainViewModel.albums.count], id: \.self){ data in
										
										NavigationLink(destination: {
                                            AlbumFeedView(mainViewModel: mainViewModel, albumDocId: data.id, viewModel: AlbumViewModel())
										}) {
											AlbumLayout(coverImage: data.albumCoverImage,
														userId: data.users,
														travelName: data.albumTitle,
														startDay: data.startDay,
														endDay: data.endDay)
											.padding(.bottom, UIScreen.getHeight(24))
										}
									}
									
									Spacer()
										.frame(height: UIScreen.getHeight(94))
								}.frame(maxWidth: .infinity)
							})
						} else if mainViewModel.hasAlbum == 1 {
							
							// albums ==> albums.count == 0
							VStack {
								Spacer()
									.frame(height: UIScreen.getHeight(45))
								NoAlbumLayout()
							}
						} else {
							ProgressView()
						}
						
						VStack{
							Spacer()
							
							HStack {
								Spacer()
								
								if mainViewModel.traveling == 1 && mainViewModel.hasAlbum == 2 {
									CameraButton(mainViewModel: mainViewModel)
										.padding(.trailing, UIScreen.getWidth(20))
								} else {
									NavigationLink(destination: NewAlbumView(mainViewModel: mainViewModel).navigationBarBackButtonHidden()) {
										ZStack {
											Circle()
												.aspectRatio(contentMode: .fit)
												.frame(height: UIScreen.getHeight(64))
												.foregroundColor(Color("B1"))
											
											Image(systemName: "plus")
												.resizable()
												.aspectRatio(contentMode: .fit)
												.frame(height: UIScreen.getHeight(24))
												.foregroundColor(.white)
										}
									}
									.padding(.trailing, UIScreen.getWidth(20))
								}
							}
						}
					}
				}
				if !mainViewModel.finishedFetch {
					ZStack {
						VStack {
							Spacer()
								.frame(height: UIScreen.getHeight(60))
							
							Rectangle()
								.foregroundColor(.white)
								.ignoresSafeArea()
						}
						
						ProgressView()
					}
				}
			}
		}
		.onAppear {
//            2023.07.01 -> Date -> Int, Double
            mainViewModel.albums.sort{ $0.startDay > $1.startDay }
			Task {
				if !mainViewModel.fetchState {
					try await mainViewModel.loadAlbum()
					mainViewModel.fetchState = true
				}
			}
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                print("NLNLNLN \(mainViewModel.users)")
            }
		}
		
	}
}
