//
//  FriendsList.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 5/23/22.
//

import SwiftUI
import SpriteKit

struct FriendGardenView: View {
    
    var friend: User
    
    var scene: SKScene {
        let scene = FriendGardenScene()
        scene.friend = friend
        scene.scaleMode = SKSceneScaleMode.resizeFill
        return scene
        
    }
    
    var body: some View {
        ZStack{
            SpriteView(scene: scene)
                .edgesIgnoringSafeArea(.top)
            VStack {
                HStack {
                    
               
                    Spacer()
                    
                    
                }
                .padding(20)
                Spacer()
            }
            
        }
    }
    
}

struct FriendsList: View {
    
    @EnvironmentObject var friendsViewModel: FriendsViewModel
    
    var body: some View {
        ZStack {
            
            MainBackground()
            
//            List(friendsViewModel.friendsList){ friend in
//                NavigationLink(destination: FriendGardenView(friend: friend)) {
//                    Text(friend.name)
//                }
//            }
        }
    }
}


struct FriendsList_Previews: PreviewProvider {
    static var previews: some View {
        FriendsList()
            .environmentObject(FriendsViewModel())
    }
}
