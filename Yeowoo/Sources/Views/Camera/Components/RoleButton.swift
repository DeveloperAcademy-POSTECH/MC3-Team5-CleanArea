//
//  RoleButton.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/16.
//

import SwiftUI

struct RoleButton: View {
    let roleTitle: String
    let roleContents: String
    let imageColor: Color
    var isSelected: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("G6"))
                .frame(width: UIScreen.getWidth(350), height: UIScreen.getHeight(70))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 1.5)
                        .foregroundColor(isSelected ? Color("ButtonColor") : .clear)
                }
            
            HStack {
                Spacer()
                    .frame(width: UIScreen.getWidth(38))
                
                Image(isSelected == true ? "CheckCircle" : "EmptyCircle")
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.getWidth(24))
                
                Spacer()
                    .frame(width: UIScreen.getWidth(18))
                
                VStack {
                    Text(roleTitle)
                        .foregroundColor(Color("G1"))
                        .font(.custom16bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                        .frame(height: UIScreen.getHeight(4))
                    
                    Text(roleContents)
                        .foregroundColor(Color("G2"))
                        .font(.custom14semibold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer()
            }
        }
    }
}
