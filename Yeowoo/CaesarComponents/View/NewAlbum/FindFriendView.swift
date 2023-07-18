//
//  FindFriendView.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/18.
//

import SwiftUI

struct FindFriendView: View {

    @Environment(\.dismiss) var dismiss
    
    @State var friendID: String = ""
    @State var myFriend: Array = [{}]


    var body: some View {
        VStack(alignment: .leading){
            Rectangle()
                .frame(width: UIScreen.width - 50, height: 3)
                .padding(.top, 15)
            .foregroundColor(.mainColor)
            
            Text("친구 찾기")
                .font(.system(size: 18, weight: .bold, design: .default))
                .foregroundColor(.friendGray)
                .padding(.top, 35)
            
            ZStack {
                GrayTitleMakingView(placeholder: "친구 아이디를 입력해주세요", text: $friendID)
                
                HStack {
                    Spacer()
                        .frame(width: UIScreen.width - 110)
                    Button {
                        friendID = ""
                 } label: {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: 24, height: 24)
                        .foregroundColor(.alarmGray)
                    }
                }
            }
            .padding(.bottom, 20)
            
            FindFriendContents(user: users[2])
            FindFriendContents(user: users[3])
            
            Spacer()
            
            if !myFriend.isEmpty {
                Button{
                        //선택 완료(선택된 friendName 넘기기)
                    
                        
                        
                    } label: {
                        Rectangle()
                            .frame(width: UIScreen.main.bounds.width - 30, height: 54)
                            .foregroundColor(Color.mainColor)
                            .cornerRadius(10)
                            .overlay(Text("선택완료").font(.system(size: 18, weight: .bold, design: .default)).foregroundColor(Color.white))
                            .padding(.bottom, 20)
                    }
                
            } else {
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width - 30, height: 54)
                        .foregroundColor(Color.unclicked)
                        .cornerRadius(10)
                        .overlay(Text("선택완료").font(.system(size: 18, weight: .bold, design: .default)).foregroundColor(Color.white))
                        .padding(.bottom, 20)
            }
        }
        .navigationTitle(Text("친구 초대하기"))
        .navigationBarTitleDisplayMode(.inline)
        .background(.white)
        .modifier(BackToolBarModifier())
        
    }
}

struct FindFriendView_Previews: PreviewProvider {
    static var previews: some View {
        FindFriendView()
    }
}
