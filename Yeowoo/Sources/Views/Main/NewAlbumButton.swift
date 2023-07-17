//
//  NewAlbumButton.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/17.
//

import SwiftUI

struct NewAlbumButton: View {
    var body: some View {
        Button(action: {
            
        }) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.getWidth(76))
                .foregroundColor(Color("ButtonColor"))
        }
    }
}

struct NewAlbumButton_Previews: PreviewProvider {
    static var previews: some View {
        NewAlbumButton()
    }
}
