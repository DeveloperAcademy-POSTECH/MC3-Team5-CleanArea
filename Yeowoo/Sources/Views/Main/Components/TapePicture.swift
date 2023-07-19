//
//  TapePicture.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/17.
//

import SwiftUI

struct TapePicture: View {
    var picture: Color
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Button(action: {
                    
                }) {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(picture)
                        .frame(height: UIScreen.getHeight(140))
                }
            }
            
            VStack {
                Image("Tape")
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.getWidth(16), height: UIScreen.getHeight(32))
                
                Spacer()
            }
        }.frame(width: UIScreen.getWidth(105), height: UIScreen.getHeight(160))
    }
}

struct TapePicture_Previews: PreviewProvider {
    static var previews: some View {
        TapePicture(picture: .pink)
    }
}
