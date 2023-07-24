//
//  TravelLabel.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/17.
//

import SwiftUI

struct TravelLabel: View {
    var travelText: String
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
                .frame(width: UIScreen.getWidth(10), height: UIScreen.getHeight(24))
            
            Circle()
                .frame(width: UIScreen.getWidth(7))
                .foregroundColor(Color("R1"))
            
            Spacer()
                .frame(width: 4)
            
            Text(travelText)
                .foregroundColor(.white)
                .font(.custom14semibold())
            
            Spacer()
                .frame(width: UIScreen.getWidth(10))
        }.background(Color("DarkBG")
            .opacity(0.4)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .frame(maxWidth: .infinity))
    }
}

struct TravelLabel_Previews: PreviewProvider {
    static var previews: some View {
        TravelLabel(travelText: "여행중")
    }
}
