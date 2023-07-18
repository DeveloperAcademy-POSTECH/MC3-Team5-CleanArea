//
//  FoxCardView.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/17.
//

import SwiftUI


struct FoxCardView: View {
    
    let fox : Fox
    var isSelected : Bool
    
    var body: some View {
        VStack{
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 108, height: 108)
                    .foregroundColor(isSelected ? .clicked : .whiteGray)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 1.5)
                            .foregroundColor(isSelected ? .mainColor : .clear)
                    }
                
                    
                
                VStack {
                    Image(fox.foxImage)
                        .resizable()
                        .scaledToFill()
                    .frame(width: 46, height: 48)
                    Text(fox.foxName)
                        .font(.system(size: 16, weight: .bold, design: .default))
                }
            }
            
            
            Text(fox.description)
                .font(.system(size: 12, weight: .medium, design: .default))
                .multilineTextAlignment(.center)
                .foregroundColor(.alarmGray)
            
            
        }
    }
}

struct FoxCardView_Previews: PreviewProvider {
    static var previews: some View {
        FoxCardView(fox: foxs[0], isSelected: false)
    }
}
