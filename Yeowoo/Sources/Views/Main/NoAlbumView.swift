//
//  NoAlbum.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/17.
//

import SwiftUI

struct NoAlbumView: View {
    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(uiColor: .secondarySystemBackground))
                .frame(width: UIScreen.getWidth(350), height: UIScreen.getWidth(350))
            
            Spacer()
                .frame(height: UIScreen.getHeight(24))
            
            Text("첫 번째 여행을 기록해보세요!")
                .font(.custom20bold())
                .padding(.bottom, UIScreen.getHeight(10))
            
            Text("새 앨범을 만들어 여행 중 추억을 남겨보세요")
                .foregroundColor(Color(uiColor: .systemGray2))
                .font(.custom14regular())
            
            Spacer()
        }
    }
}

struct NoAlbumView_Previews: PreviewProvider {
    static var previews: some View {
        NoAlbumView()
    }
}
