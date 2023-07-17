//
//  MainView.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/17.
//

import SwiftUI

struct MainView: View {
    @State var traveling = 0
    @State var hasAlarm = false
    @State var hasAlbum = false
    @State var today: String = ""
    
    var body: some View {
        VStack {
            Image("YeowooNavigation")
            Spacer()
                .frame(height: UIScreen.getHeight(hasAlbum == true ? 35 : 84))
            
            ZStack {
                if hasAlbum {
                    ScrollView(.vertical, showsIndicators: true, content: {
                        VStack {
                            if !(traveling == 2) {
                                if traveling == 1{
                                    RecommendView()
                                    Spacer()
                                        .frame(height: UIScreen.getHeight(41))
                                } else {
                                    BeforeTravelView()
                                }
                                
                                HStack {
                                    Spacer()
                                        .frame(width: UIScreen.getWidth(20))
                                    if traveling == 1{
                                        Text("지금 쌓고 있는 추억")
                                            .font(.custom18bold())
                                        Spacer()
                                    }
                                }
                                
                                AlbumView(arr: dummyData[dummyData.count-1].withPerson,
                                          travelName: dummyData[dummyData.count-1].albumName,
                                          startDay: dummyData[dummyData.count-1].startDay,
                                          endDay: dummyData[dummyData.count-1].endDay)
                                
                                Spacer()
                                    .frame(height: UIScreen.getHeight(45))
                            } else if dummyData[dummyData.count-1].endDay == today {
                                DoneTravelView(albumName: dummyData[dummyData.count-1].albumName)
                                
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
                            ForEach(dummyData[0..<(traveling == 2 ? dummyData.count : dummyData.count-1)].reversed(),
                                    id: \.self) { data in
                                AlbumView(arr: data.withPerson, travelName: data.albumName, startDay: data.startDay, endDay: data.endDay)
                                    .padding(.bottom, UIScreen.getHeight(10))
                            }
                        }.frame(maxWidth: .infinity)
                    })
                } else {
                    NoAlbumView()
                }
                
                Spacer()
                    .frame(width: UIScreen.getWidth(20))
                
                VStack{
                    Spacer()
                    
                    HStack {
                        Spacer()
                            .frame(width: UIScreen.getWidth(20))
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 100)
                                .foregroundColor(Color(uiColor: .secondarySystemBackground))
                                .frame(width: UIScreen.getWidth(158), height: UIScreen.getHeight(76))
                            HStack {
                                Button(action: {
                                    hasAlarm = false
                                }) {
                                    Image(hasAlarm == true ? "hasAlarm" : "noAlarm")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: UIScreen.getHeight(48))
                                }
                                
                                Spacer()
                                    .frame(width: UIScreen.getWidth(16))
                                
                                Button(action: {
                                    
                                }) {
                                    Image("Gear")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: UIScreen.getHeight(48))
                                }
                            }
                        }
                        
                        Spacer()
                        
                        if (traveling == 0 || traveling == 1) && hasAlbum {
                            CameraButtonView()
                                .padding(.trailing, UIScreen.getWidth(20))
                        } else {
                            NewAlbumButton()
                                .padding(.trailing, UIScreen.getWidth(20))
                        }
                    }
                }
            }
        }
        .onAppear {
            traveling = hasTraveling()
            getCurrentDateTime(&today)
            hasAlbum = hasEmpty()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

