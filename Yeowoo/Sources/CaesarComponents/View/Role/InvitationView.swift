//
//  InvitationView.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/19.
//

import SwiftUI

struct InvitationView: View {
    
    //유저 인원수 받기
    @State var invitedFriends: [SubUser] = [users[0], users[1]]
    
    var body: some View {
        if invitedFriends.count < 3 {
            TwoInvitationView()
        } else {
            MultiInvitationView()
        }
    }
}

struct InvitationView_Previews: PreviewProvider {
    static var previews: some View {
        InvitationView()
    }
}
