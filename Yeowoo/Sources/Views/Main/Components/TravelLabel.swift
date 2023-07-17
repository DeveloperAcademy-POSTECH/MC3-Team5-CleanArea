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
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("ButtonColor"))
                .frame(width: UIScreen.getWidth(57), height: UIScreen.getHeight(24))
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .frame(width: UIScreen.getWidth(56), height: UIScreen.getHeight(23))
            
            Text(travelText)
                .foregroundColor(Color("ButtonColor"))
                .font(.custom14semibold())
        }

    }
}

struct TravelLabel_Previews: PreviewProvider {
    static var previews: some View {
        TravelLabel(travelText: "여행중")
    }
}
