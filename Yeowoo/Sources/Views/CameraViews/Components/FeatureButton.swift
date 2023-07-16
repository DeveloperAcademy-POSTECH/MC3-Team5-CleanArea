//
//  Buttons.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/16.
//

import SwiftUI

struct FeatureButton: View {
    let imageName: String
    var body: some View {
        ZStack {
            Circle()
                .aspectRatio(contentMode: .fit)
                .frame(height: UIScreen.getHeight(48))
                .foregroundColor(Color(uiColor: .secondarySystemBackground))
            
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: UIScreen.getWidth(22))
                .foregroundColor(.gray)
        }
    }
}

struct FeatureButton_Previews: PreviewProvider {
    static var previews: some View {
        FeatureButton(imageName: "bolt")
    }
}
