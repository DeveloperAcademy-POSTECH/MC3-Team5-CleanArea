//
//  BeforeTravelLayout.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/17.
//

import SwiftUI

struct BeforeTravelLayout: View {
	@StateObject var mainViewModel: MainViewModel
    @State var fetch: Bool = false
    @State var date: Int = 0
    @Binding var role: String
    var nickname: String
    var startDay: String
    
    var body: some View {
        VStack {
			HStack {
				VStack(alignment: .leading, spacing: 3) {
					Text("\(nickname)님,")
					Text("여행까지 ") +
					Text("\(date)일 ").foregroundColor(Color("B1")) +
					Text("남았어요!")
				}
				Spacer()
                
                VStack {
                    NavigationLink(destination :
									RoleChangeView(mainViewModel: mainViewModel, album: mainViewModel.albums.first!)
                            .navigationBarBackButtonHidden(), isActive: $mainViewModel.openChange) {
                        Button(action: {
                            mainViewModel.openChange.toggle()
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
                                        .frame(width: UIScreen.getWidth(22.5), height: UIScreen.getHeight(20))
                                    
                                    Text("내 역할")
                                        .font(.custom14semibold())
                                        .foregroundColor(Color("G1"))
                                    
                                    Spacer()
                                        .frame(width: UIScreen.getWidth(10))
                                }
                            }
                        }
                    }
                    .padding(.top, UIScreen.getHeight(5))
                    
                    Spacer()
                }
            }
            .font(.custom24bold())
            .frame(width: UIScreen.getWidth(350), height: UIScreen.getHeight(68))
        }
        .onAppear {
            if !fetch {
                date = mainViewModel.D_Day(startDay)
                fetch = true
            }
        }
    }
}
