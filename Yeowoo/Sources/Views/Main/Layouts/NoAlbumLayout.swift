//
//  NoAlbumLayout.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/17.
//

import SwiftUI

struct NoAlbumLayout: View {
    var body: some View {
        VStack(spacing: 0) {
            Image("EmptyFox")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.getWidth(247), height: UIScreen.getWidth(290))
            
            Spacer()
                .frame(height: UIScreen.getHeight(24))
            
            Text("첫 번째 여행을 기록해보세요!")
                .foregroundColor(Color("G1"))
                .font(.custom20bold())
                .padding(.bottom, UIScreen.getHeight(10))
            
            Text("새 앨범을 만들어 여행 중 추억을 남겨보세요")
                .foregroundColor(Color("G3"))
                .font(.custom14regular())
            
            Spacer()
        }
    }
}

struct NoAlbumLayout_Previews: PreviewProvider {
    static var previews: some View {
        NoAlbumLayout()
    }
}
