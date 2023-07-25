//
//  RecommendLayout.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/17.
//

import SwiftUI

struct RecommendLayout: View {
    @StateObject var mainViewModel = MainViewModel()
    @Binding var role: String
    var startday: String
    var nickname: String
    @State var date: Int = 0
    var body: some View {
        ZStack {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("\(nickname)님")
                    Text("여행 ") +
                    Text("\(date)일차").foregroundColor(Color("ButtonColor")) +
                    Text("인 오늘")
                    Text("친구들과 단체사진 어떠세요?")
                }
                Spacer()
            }
            .font(.custom24bold())
            .frame(width: UIScreen.getWidth(350), height: UIScreen.getHeight(102))
            
            HStack {
                Spacer()
                
                VStack {
                    NavigationLink(destination: {
                        
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 100)
                                .frame(width: UIScreen.getWidth(90), height: UIScreen.getHeight(32))
                                .foregroundColor(.white)
                                .background(Color("G4")
                                    .opacity(0.08)
                                    .clipShape(RoundedRectangle(cornerRadius: 100))
                                    .shadow(color: .black, radius: 1, x: 0, y: 4)
                                    .blur(radius: 4, opaque: false))
                            
                            HStack {
                                Spacer()
                                    .frame(width: UIScreen.getWidth(10))
                                
                                Image(role)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: UIScreen.getWidth(22.5), height: UIScreen.getHeight(25))
                                
                                Spacer()
                                    .frame(width: UIScreen.getWidth(6))
                                
                                Text("내 역할")
                                    .font(.custom14semibold())
                                    .foregroundColor(Color("G1"))
                                
                                Spacer()
                                    .frame(width: UIScreen.getWidth(10))
                            }
                        }
                    }
                    .padding(.top, UIScreen.getHeight(5))
                    
                    Spacer()
                }
            }
            .frame(width: UIScreen.getWidth(350), height: UIScreen.getHeight(102))
        }.onAppear {
            date = mainViewModel.travelingDate(startday)
        }
    }
}
