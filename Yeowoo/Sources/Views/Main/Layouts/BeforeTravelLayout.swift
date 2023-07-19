//
//  BeforeTravelLayout.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/17.
//

import SwiftUI

struct BeforeTravelLayout: View {
    @State var date: Int = 0
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("노루궁뎅이님,")
                    Text("여행까지 ") +
                    Text("\(date)일 ").foregroundColor(Color("ButtonColor")) +
                    Text("남았어요!")
                }
                Spacer()
                
                VStack {
                    Button(action: {
                        
                    }) {
                        Image("nextButton")
                    }
                    .padding(.top, UIScreen.getHeight(5))
                    
                    Spacer()
                }
            }
            .font(.custom24bold())
            .frame(width: UIScreen.getWidth(350), height: UIScreen.getHeight(68))
        }
        .onAppear {
            date = D_Day(dummyData[dummyData.count-1].startDay)
        }
    }
}

struct BeforeTravelLayout_Previews: PreviewProvider {
    static var previews: some View {
        BeforeTravelLayout()
    }
}
