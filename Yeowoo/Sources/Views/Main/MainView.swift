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
                    .frame(height: UIScreen.getHeight(mainViewModel.hasAlbum == true ? 35 : 84))
                
                ZStack {
                    if mainViewModel.hasAlbum {
                        ScrollView(.vertical, showsIndicators: true, content: {
                            VStack {
                                if !(mainViewModel.traveling == 2) {
                                    if mainViewModel.traveling == 1{
                                        RecommendLayout()
                                        Spacer()
                                            .frame(height: UIScreen.getHeight(41))
                                    } else {
                                        BeforeTravelLayout()
                                    }
                                    
                                    HStack {
                                        Spacer()
                                            .frame(width: UIScreen.getWidth(20))
                                        if mainViewModel.traveling == 1{
                                            Text("지금 쌓고 있는 추억")
                                                .font(.custom18bold())
                                            Spacer()
                                        }
                                    }
                                    NavigationLink(destination: {
                                        EmptyView()
                                    }) {
                                        AlbumLayout(arr: dummyData[dummyData.count-1].withPerson,
                                                  travelName: dummyData[dummyData.count-1].albumName,
                                                  startDay: dummyData[dummyData.count-1].startDay,
                                                  endDay: dummyData[dummyData.count-1].endDay)
                                    }
                                    
                                    Spacer()
                                        .frame(height: UIScreen.getHeight(45))
                                } else if dummyData[dummyData.count-1].endDay == mainViewModel.today {
                                    DoneTravelLayout(albumName: dummyData[dummyData.count-1].albumName)
                                    
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
                                ForEach(dummyData[0..<(mainViewModel.traveling == 2 ? dummyData.count : dummyData.count-1)].reversed(),
                                        id: \.self) { data in
                                    
                                    NavigationLink(destination: {
                                        EmptyView()
                                    }) {
                                        AlbumLayout(arr: data.withPerson, travelName: data.albumName, startDay: data.startDay, endDay: data.endDay)
                                            .padding(.bottom, UIScreen.getHeight(10))
                                    }
                                }
                                
                                Spacer()
                                    .frame(height: UIScreen.getHeight(94))
                            }.frame(maxWidth: .infinity)
                        })
                    } else {
                        NoAlbumLayout()
                    }
                    
                    VStack{
                        Spacer()
                        
                        HStack {
                            
                            Spacer()
                            
                            if (mainViewModel.traveling == 0 || mainViewModel.traveling == 1) && mainViewModel.hasAlbum {
                                CameraButton()
                                    .padding(.trailing, UIScreen.getWidth(20))
                            } else {
                                NavigationLink(destination: EmptyView()) {
                                    Image(systemName: "plus.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: UIScreen.getWidth(76))
                                        .foregroundColor(Color("ButtonColor"))
                                }
                                .padding(.trailing, UIScreen.getWidth(20))
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            mainViewModel.hasTraveling()
            mainViewModel.getCurrentDateTime()
            mainViewModel.hasEmpty()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

