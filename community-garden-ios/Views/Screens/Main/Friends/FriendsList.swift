//
//  FriendsList.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 5/23/22.
//

import SwiftUI
import SpriteKit


struct FriendsList: View {
    
    @EnvironmentObject var friendsViewModel: FriendsViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                
                MainBackground()
                
                ScrollView {
                    VStack {
                        ForEach(/*@START_MENU_TOKEN@*/0 ..< 5/*@END_MENU_TOKEN@*/) { item in
                            Garden()
                        }
                    }
                }
            }
            .navigationBarTitle("My Friends", displayMode: .inline)
        }
        .navigationViewStyle(.stack)
    }
}

struct FriendsList_Previews: PreviewProvider {
    static var previews: some View {
        FriendsList()
            .environmentObject(FriendsViewModel())
    }
}
