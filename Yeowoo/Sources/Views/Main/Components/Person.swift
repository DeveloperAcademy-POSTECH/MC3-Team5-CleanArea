//
//  Person.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/17.
//

import SwiftUI

struct Person: View {
    var person: String
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.white)
                .frame(width: UIScreen.getWidth(32))
            
            AsyncImage(url: URL(string: person)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.getWidth(31))
                    .clipShape(Circle())
            } placeholder: {
                Image("EmptyProfile")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.getWidth(31))
                    .clipShape(Circle())
            }
        }
    }
}
