//
//  FriendGarden.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 16/07/2022.
//

import SwiftUI

struct FriendGarden: View {
    
    @State private var isShowingSheet = false
    var garden: UserGarden
    var user: User = UserService.user
    
    var gardenName: String {
        if let settings = garden.user.settings {
            return settings.gardenName
        }
        return ""
    }
    
    var body: some View {
        Garden(garden: garden)
            .sheet(isPresented: $isShowingSheet, content: {
                MessageOptions(user: garden.user)
            })
            .navigationTitle(gardenName)
            .toolbar {
                ToolbarItem {
                    Button {
                        isShowingSheet = true
                    } label: {
                        Image(systemName: "paperplane")
                    }
                }
            }
            .onAppear {
                SproutAnalytics.shared.viewFriendGarden(friendData: ["ownerName": garden.user.name,
                                                                     "ownerID": garden.user.id])
            }
    }
}

struct FriendGarden_Previews: PreviewProvider {
    static let garden = getSampleUserGarden()
    static var previews: some View {
        FriendGarden(garden: garden)
    }
}
