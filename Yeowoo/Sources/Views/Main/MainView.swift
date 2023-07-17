//
//  MainView.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/17.
//

import SwiftUI

struct MainView: View {
    @State var hasAlarm = false
    @State var traveling = true
    @State var hasAlbum = false
    
    var body: some View {
        VStack {
            Image("YeowooNavigation")
            Spacer()
                .frame(height: UIScreen.getHeight(84))
            
            ZStack {
                if hasAlbum {
                    
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
                        
                        if traveling {
                            CameraButtonView()
                                .padding(.trailing, UIScreen.getWidth(20))
                        } else {
                            
                        }
                    }
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

