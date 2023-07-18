//
//  NotiCardContentsView.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/14.
//

import SwiftUI

struct NotiCardContentsView: View {
    
    let travel : Travel
    
    
    var body: some View {
        NavigationLink{
            InvitationView()
                .navigationBarBackButtonHidden()
        }label: {
            Image(travel.friendImage)
                .resizable()
                .scaledToFill()
                .frame(width: 42, height: 42)
                .clipShape(Circle())
                .padding(.horizontal, 12 )
            
            HStack{
                VStack(alignment: .leading){
                    Text("From. \(travel.name)").font((.system(size: 12, weight: .semibold, design: .default)))
                        .foregroundColor(.gray)
                    Text("\(travel.description)에 초대해요!")
                        .font((.system(size: 15, weight: .regular, design: .default)))
                        .foregroundColor(.black)
                }
                
                Spacer()

                    Image(systemName: "chevron.right")
                        .imageScale(.large)
                        .foregroundColor(.gray)
                        .opacity(0.3)
                        .padding(.trailing, 20)
            }
        }
    }
}

struct NotiCardContentsView_Previews: PreviewProvider {
    static var previews: some View {
        NotiCardContentsView(travel: travels[0])
    }
}
