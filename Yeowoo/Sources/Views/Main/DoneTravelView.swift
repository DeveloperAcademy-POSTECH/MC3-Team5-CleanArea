//
//  DoneTravelView.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/17.
//

import SwiftUI

struct DoneTravelView: View {
    var albumName: String
    @State var picture: [Color] = [.pink, .blue, .purple]
    
    var body: some View {
        VStack {
            HStack(spacing: UIScreen.getWidth(10)) {
                VStack(alignment: .leading, spacing: UIScreen.getHeight(3)) {
                    Text("노루궁뎅이님")
                    Text("\(albumName)").foregroundColor(Color("ButtonColor")) +
                    Text("에서")
                    Text("즐거웠던 추억을 되돌아보세요!")
                }
                
                Spacer()
            }
            .font(.custom24bold())
            .frame(width: UIScreen.getWidth(350), height: UIScreen.getHeight(102))
            
            ZStack {
                VStack {
                    ZStack {
                        Spacer()
                            .frame(height: UIScreen.getHeight(20))
                        Image("Line")
                        
                        HStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: UIScreen.getWidth(48), height: UIScreen.getHeight(7))
                                .background(
                                    LinearGradient(
                                        stops: [
                                            Gradient.Stop(color: .white, location: 0.43),
                                            Gradient.Stop(color: .white.opacity(0), location: 1.00),
                                        ],
                                        startPoint: UnitPoint(x: 0, y: 0.57),
                                        endPoint: UnitPoint(x: 1, y: 0.57)
                                    )
                                )
                            
                            Spacer()
                            
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: UIScreen.getWidth(48), height: UIScreen.getHeight(7))
                                .background(
                                    LinearGradient(
                                        stops: [
                                            Gradient.Stop(color: .white, location: 0.43),
                                            Gradient.Stop(color: .white.opacity(0), location: 1.00),
                                        ],
                                        startPoint: UnitPoint(x: 0, y: 0.57),
                                        endPoint: UnitPoint(x: 1, y: 0.57)
                                    )
                                )
                        }
                    }
                    
                    Spacer()
                }
                HStack(spacing: 18) {
                    ForEach(0..<3) { num in
                        TapePicture(picture: picture[num])
                    }
                }
            }.frame(maxHeight: UIScreen.getHeight(160))
        }
        .onAppear {
            randomPicture(Colors, &picture)
        }
    }
}

struct DoneTravelView_Previews: PreviewProvider {
    static var previews: some View {
        DoneTravelView(albumName: "제주도 여행")
    }
}
