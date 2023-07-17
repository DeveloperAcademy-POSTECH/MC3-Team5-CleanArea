//
//  Person.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/17.
//

import SwiftUI

struct Person: View {
    var person: Color
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.white)
                .frame(width: 32)
            Circle()
                .foregroundColor(person)
                .frame(width: 31)
        }
    }
}

struct Person_Previews: PreviewProvider {
    static var previews: some View {
        Person(person: .blue)
    }
}
