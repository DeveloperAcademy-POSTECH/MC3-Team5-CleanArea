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
    @State var myFriend: [SubUser] = []
    
    //firebase에서는 앨범별로 폴더를 만들어서 유저를 넣을거 같은데 일단 여기는 선택된 유저 누군지 남길게요
    //selectedFriends에 있는 대상이 선택된 대상이에요
    @State var selectedFriends: [SubUser] = []
    @State var friendToggles: [Bool] = []


    var body: some View {
        VStack(alignment: .center){
            Rectangle()
                .frame(width: UIScreen.width - 50, height: 3)
                .padding(.top, 15)
            .foregroundColor(.mainColor)
            
            Text("친구 찾기")
                .font(.system(size: 18, weight: .bold, design: .default))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.friendGray)
                .padding(.top, 35)
                .padding(.leading, 30)
            
            ZStack {
                GrayTitleMakingView(placeholder: "친구 아이디를 입력해주세요", text: $friendID)
                
                HStack {
                    Spacer()
                        .frame(width: UIScreen.width - 110)
                    Button {
                        let foundUsers = users.filter { $0.nickname == friendID }

                        for user in foundUsers {
                            if !myFriend.contains(where: { $0.id == user.id }) {
                                myFriend.insert(user, at: 0)
                                friendToggles.insert(false, at: 0)
                            }
                        }
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: 24, height: 24)
                        .foregroundColor(.alarmGray)
                    }
                }
            }
            .padding(.bottom, 20)
            
            ScrollView{
                ForEach(myFriend.indices, id: \.self) { index in
                    FindFriendContents(user: myFriend[index], friendToggle: $friendToggles[index])
                }
                
                Spacer()
            }
            
                Button{
                        //선택 완료(선택된 selectedfriend 넘기기)
                    selectedFriends = myFriend.indices.filter { friendToggles[$0] }.map { myFriend[$0] }
                        
                    print(selectedFriends)
                        
                    } label: {
                        Rectangle()
                            .frame(width: UIScreen.main.bounds.width - 30, height: 54)
                            .foregroundColor(Color.mainColor)
                            .cornerRadius(10)
                            .overlay(Text("여행 시작하기").font(.system(size: 18, weight: .bold, design: .default)).foregroundColor(Color.white))
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
