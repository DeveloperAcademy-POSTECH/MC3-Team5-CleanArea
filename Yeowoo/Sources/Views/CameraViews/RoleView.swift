//
//  RoleView.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/16.
//

import SwiftUI

struct RoleView: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: UIScreen.getHeight(24))
            
            Text("역할 체크하기")
                .font(.custom18bold())
            
            Spacer()
                .frame(height: UIScreen.getHeight(24))
            
            RoleButton(image: "checkmark.circle.fill", roleTitle: "역할 사진", roleContents: "내 역할에 해당하는 사진이에요", imageColor: Color("ButtonColor"))
            
            Spacer()
                .frame(height: UIScreen.getHeight(8))
            
            RoleButton(image: "xmark.circle.fill", roleTitle: "자유 사진", roleContents: "내 역할에 해당하지 않는 사진이에요", imageColor: .red)
            
        }
    }
}

struct RoleView_Previews: PreviewProvider {
    static var previews: some View {
        RoleView()
    }
}
