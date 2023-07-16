//
//  RoleButton.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/16.
//

import SwiftUI

struct RoleButton: View {
    let image: String
    let roleTitle: String
    let roleContents: String
    let imageColor: Color
    var body: some View {
        Button(action: {
            
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(uiColor: .secondarySystemBackground))
                    .frame(width: UIScreen.getWidth(350), height: UIScreen.getHeight(70))

                HStack {
                    Spacer()
                        .frame(width: UIScreen.getWidth(38))
                    
                    Image(systemName: image)
                        .foregroundColor(imageColor)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.getWidth(24))
                    
                    Spacer()
                        .frame(width: UIScreen.getWidth(18))
                    
                    VStack{
                        Text(roleTitle)
                            .foregroundColor(.black)
                            .font(.custom16bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                        Text(roleContents)
                            .foregroundColor(Color(uiColor: .systemGray))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Spacer()
                }
            }
        }
    }
}
