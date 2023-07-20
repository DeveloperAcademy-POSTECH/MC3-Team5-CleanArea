//
//  RoleView.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/16.
//

import SwiftUI

struct RoleView: View {
    @Binding var myAlbum: Bool
    @Binding var allAlbum: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: UIScreen.getHeight(24))
            
            Text("역할 체크하기")
                .font(.custom18bold())
            
            Spacer()
                .frame(height: UIScreen.getHeight(24))
            
            Button(action: {
                change(&myAlbum, &allAlbum)
            }) {
                RoleButton(roleTitle: "내 역할 앨범", roleContents: "내 역할 앨범과 전체 앨범에 사진이 업로드돼요", imageColor: Color("ButtonColor"), isSelected: myAlbum)
            }
            
            Spacer()
                .frame(height: UIScreen.getHeight(8))
            Button(action: {
                change(&allAlbum, &myAlbum)
            }) {
                RoleButton(roleTitle: "전체 앨범", roleContents: "전체 앨범에만 사진이 업로드돼요", imageColor: Color("ButtonColor"), isSelected: allAlbum)
            }
        }
    }
}

struct RoleView_Previews: PreviewProvider {
    static var previews: some View {
        RoleView(myAlbum: .constant(true), allAlbum: .constant(false))
    }
}
