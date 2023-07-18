//
//  NotifcationCardView.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/14.
//

import SwiftUI

struct NotiCardView: View {
    @State var dayNotiNum: Int = 1
    
    let travels : [Travel]
    
    var body: some View {
        
        VStack {
            Text(travels.first?.Date ?? "None")
                .font(.system(size: 18, weight: .semibold, design: .default))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                .padding(.bottom, 20)
            
            ForEach(Array(travels.enumerated()), id: \.element.id) { index, travel in
                NotiCardContentsView(travel: travel)

                // Check if current item is not the last one
                if index != travels.count - 1 {
                    Divider()
                        .frame(width: UIScreen.width - 50)
                }
            }
        }
        .padding(.bottom, 49)
        .modifier(CardViewModifier(height: CGFloat(65 * dayNotiNum)))
    }
}

struct NotiCardView_Previews: PreviewProvider {
    static var previews: some View {
        NotiCardView(dayNotiNum: 1, travels: [travels[0]])
    }
}
