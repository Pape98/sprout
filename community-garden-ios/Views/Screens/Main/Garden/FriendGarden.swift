//
//  FriendGarden.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 16/07/2022.
//

import SwiftUI

struct FriendGarden: View {
    
    var garden: UserGarden
    
    var body: some View {
        Garden(garden: garden)
    }
}

struct FriendGarden_Previews: PreviewProvider {
    static let user = User(id: "pape", name: "Pape Sow", email: "", group: 0)
    static let gardenItems: [GardenItem] = []
    static let garden = UserGarden(user: user, items: gardenItems)
    static var previews: some View {
        FriendGarden(garden: garden)
    }
}
