//
//  RecommendView.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/17.
//

import SwiftUI

struct RecommendView: View {
    @State var date: Int = 0
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("노루궁뎅이님")
                    Text("여행 ") +
                    Text("\(date)일차").foregroundColor(Color("ButtonColor")) +
                    Text("인 오늘")
                    Text("친구들과 단체사진 어떠세요?")
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
            .frame(width: UIScreen.getWidth(350), height: UIScreen.getHeight(102))
            
            Spacer()
                .frame(height: UIScreen.getHeight(24))
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(uiColor: .secondarySystemBackground))
                .frame(width: UIScreen.getWidth(350), height: UIScreen.getHeight(154))
        }
        .onAppear {
            date = travelingDate(dummyData[dummyData.count-1].startDay)
        }
    }

}

struct RecommendView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendView()
    }
}
