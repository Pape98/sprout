//
//  GardenScene.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 14/07/2022.
//

import SwiftUI
import SpriteKit

struct Garden: View {
    
    @EnvironmentObject var friendsViewModel: FriendsViewModel
    var garden: UserGarden
    var isAnimated: Bool = true
    let weatherInfo = getWeatherInfo()
    
    var scene: SKScene {
        let scene = FriendGardenScene()
        scene.scaleMode = .resizeFill
        scene.garden = garden
        scene.isAnimated = isAnimated
        return scene
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            SpriteView(scene: scene, options: [.allowsTransparency])
                .weatherOverlay(showStats: false, opacity: 0.8)

            Text(garden.user.name)
                .bodyStyle()
                .padding()
        }
    }
}

struct Garden_Previews: PreviewProvider {
    static let user = User(id: "pape", name: "Pape Sow", email: "", group: 0)
    static let gardenItems: [GardenItem] = []
    static let garden = UserGarden(user: user, items: gardenItems)
    
    static var previews: some View {
        Garden(garden: garden)
            .frame(width: 300, height: 300)
            .environmentObject(UserViewModel())
            .environmentObject(FriendsViewModel())
    }
}
