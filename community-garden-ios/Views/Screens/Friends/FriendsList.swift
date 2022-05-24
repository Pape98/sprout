//
//  FriendsList.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 5/23/22.
//

import SwiftUI

struct FriendView: View {
    
    var friend: User
    
    var body: some View {
        Text(friend.name)
    }
}

struct FriendsList: View {
    
    @EnvironmentObject var friendsViewModel: FriendsViewModel
    
    var body: some View {
        List(friendsViewModel.friendsList){ friend in
            NavigationLink(destination: FriendView(friend: friend)) {
                Text(friend.name)
            }
        }
    }
}


struct FriendsList_Previews: PreviewProvider {
    static var previews: some View {
        FriendsList()
            .environmentObject(FriendsViewModel())
    }
}
