//
//  ViewModifier.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/14.
//

import SwiftUI


struct CardViewModifier: ViewModifier {

    var height: CGFloat = 66
    
    func body(content: Content) -> some View {
        content
            .frame(width: UIScreen.main.bounds.width - 30, height: height)
            .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.white))
            .shadow(color: Color.black.opacity(0.05), radius: 20, x: 0, y: 4)
    }
}
