//
//  PlusPerson.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/17.
//

import SwiftUI

struct PlusPerson: View {
    var plusCount: Int
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.white)
                .frame(width: 32)
            Circle()
                .foregroundColor(Color(uiColor: .darkGray))
                .frame(width: 31)
            
            Text("+\(plusCount)")
                .foregroundColor(.white)
                .font(.custom12bold())
                
        }
    }
}

struct PlusPerson_Previews: PreviewProvider {
    static var previews: some View {
        PlusPerson(plusCount: 1)
    }
}
