//
//  ViewModifier.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/14.
//

import SwiftUI

struct IGTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .semibold, design: .default))
            .foregroundColor(.black)
            .opacity(0.5)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
            .padding(.top, 20)
    }
}

