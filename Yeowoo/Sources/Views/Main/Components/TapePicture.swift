//
//  TapePicture.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/17.
//

import SwiftUI

struct TapePicture: View {
    var picture: String
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                AsyncImage(url: URL(string: picture)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: UIScreen.getHeight(140))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                } placeholder: {
                    Image("EmptyCard")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: UIScreen.getHeight(140))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
            }
            
            VStack {
                Image("Tape")
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.getWidth(16), height: UIScreen.getHeight(32))
                
                Spacer()
            }
        }
        .frame(width: UIScreen.getWidth(105), height: UIScreen.getHeight(160))
    }
}

