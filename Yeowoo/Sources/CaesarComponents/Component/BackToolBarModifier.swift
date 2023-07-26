//
//  BackToolBarModifier.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/17.
//

import SwiftUI

struct BackToolBarModifier: ViewModifier {
    @Environment(\.dismiss) var dismiss
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .opacity(0.3)
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                        .onTapGesture {
                            dismiss()
                        }
                }
            }
    }
}


