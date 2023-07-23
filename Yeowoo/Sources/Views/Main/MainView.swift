//
//  MainView.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/17.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var mainViewModel = MainViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                        .frame(width: UIScreen.getWidth(20))
                    
                    Image("Title")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    Spacer()
                    
                    // Alarn, Setting 버튼
                    HStack {
                        NavigationLink(destination: EmptyView(),
                                       isActive: $mainViewModel.openAlarm) {
                            Button(action: {
                                mainViewModel.openAlarm.toggle()
                                mainViewModel.hasAlarm = false
                            }) {
                                ZStack {
                                    Image(mainViewModel.hasAlarm == true ? "AlarmBell" : "Bell")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: UIScreen.getHeight(48))
                                }
                            }
                        }
                        
                        Spacer()
                            .frame(width: UIScreen.getWidth(9))
                        
                        NavigationLink(destination: EmptyView()){
                            ZStack {
                                Image("Gear")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: UIScreen.getHeight(48))
                            }
                        }
                    }
                    
                    Spacer()
                        .frame(width: UIScreen.getWidth(20))
                }
                .frame(height: UIScreen.getHeight(48))
                Spacer()
                    .frame(height: UIScreen.getHeight(mainViewModel.hasAlbum == 2 ? 35 : 84))
                
                // 메인
                ZStack {
                    if mainViewModel.hasAlbum == 2 {
                        ScrollView(.vertical, showsIndicators: true, content: {
                            VStack {
                                if !(mainViewModel.traveling == 2) {
                                    if mainViewModel.traveling == 1 {
                                        // 친구들과 단체 사진 어떠세요?
                                        RecommendLayout(startday: mainViewModel.albums[0].startDay,
                                                        nickname: mainViewModel.users[0].nickname)
                                        Spacer()
                                            .frame(height: UIScreen.getHeight(41))
                                    } else {
                                        // 여행까지 며칠 남았어요!
                                        BeforeTravelLayout(nickname: mainViewModel.users[0].nickname,
                                                           startDay: mainViewModel.albums[0].startDay)
                                    }
                                    
                                    HStack {
                                        Spacer()
                                            .frame(width: UIScreen.getWidth(20))
                                        if mainViewModel.traveling == 1 {
                                            Text("지금 쌓고 있는 추억")
                                                .font(.custom18bold())
                                            Spacer()
                                        }
                                    }
                                    NavigationLink(destination: {
                                        EmptyView()
                                    }) {
                                        // ViewModel에 userProfileImage 가져오는 메소드 추가
                                        AlbumLayout(
                                            userId: mainViewModel.albums[0].users,
                                            coverImage: mainViewModel.albums[0].albumCoverImage,
                                            travelName: mainViewModel.albums[0].albumTitle,
                                            startDay: mainViewModel.albums[0].startDay,
                                            endDay: mainViewModel.albums[0].endDay)
                                    }
                                    
                                    Spacer()
                                        .frame(height: UIScreen.getHeight(45))
                                } else if mainViewModel.albums[0].endDay == mainViewModel.today {
                                    DoneTravelLayout(images: mainViewModel.albums[0].images,
                                                     nickname: mainViewModel.users[0].nickname,
                                                     albumName: mainViewModel.albums[0].albumTitle)
                                    
                                    Spacer()
                                        .frame(height: UIScreen.getHeight(45))
                                }
                                
                                HStack {
                                    Spacer()
                                        .frame(width: UIScreen.getWidth(20))
                                    
                                    Text("우리가 함께한 추억들")
                                        .font(.custom18bold())
                                    
                                    Spacer()
                                }
                                ForEach(mainViewModel.albums[((mainViewModel.traveling == 1 || mainViewModel.traveling == 0) ? 1 : 0)..<mainViewModel.albums.count], id: \.self){ data in
                                    
                                    NavigationLink(destination: {
                                        EmptyView()
                                    }) {
                                        AlbumLayout(
//                                            arr: data.users,
                                            userId: data.users,
                                            coverImage: data.albumCoverImage,
                                            travelName: data.albumTitle,
                                            startDay: data.startDay,
                                            endDay: data.endDay)
                                            .padding(.bottom, UIScreen.getHeight(10))
                                    }
                                }
                                
                                Spacer()
                                    .frame(height: UIScreen.getHeight(94))
                            }.frame(maxWidth: .infinity)
                        })
                    } else if mainViewModel.hasAlbum == 1 {
                        
                        // albums ==> albums.count == 0
                        NoAlbumLayout()
                    } else {
                        ProgressView()
                    }
                    
                    VStack{
                        Spacer()
                        
                        HStack {
                            
                            Spacer()
                            
                            if (mainViewModel.traveling == 0 || mainViewModel.traveling == 1) && mainViewModel.hasAlbum == 2 {
                                CameraButton()
                                    .padding(.trailing, UIScreen.getWidth(20))
                            } else {
                                NavigationLink(destination: EmptyView()) {
                                    ZStack {
                                        Circle()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: UIScreen.getHeight(76))
                                            .foregroundColor(.white)
                                        
                                        Image(systemName: "plus.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: UIScreen.getHeight(76))
                                            .foregroundColor(Color("ButtonColor"))
                                    }
                                }
                                .padding(.trailing, UIScreen.getWidth(20))
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            UserDefaultsSetting.userDocId = "Mt5DPoKI4Im0vZfq9vOl"
            mainViewModel.fetchAlbums()
            mainViewModel.fetchUser(userDocIds: ["Mt5DPoKI4Im0vZfq9vOl"])
        }
    }
}
