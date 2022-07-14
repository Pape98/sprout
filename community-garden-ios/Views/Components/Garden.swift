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
    let weatherInfo = getWeatherInfo()
    
    var scene: SKScene {
        let scene = FriendGardenScene()
        scene.scaleMode = .resizeFill
        return scene
    }
    
    var body: some View {
        
        SpriteView(scene: scene, options: [.allowsTransparency])
            .weatherOverlay(showStats: false, opacity: 0.8)
            .frame(height: 300)
            .padding()
    }
}

struct Garden_Previews: PreviewProvider {
    static var previews: some View {
        Garden()
            .environmentObject(UserViewModel())
            .environmentObject(FriendsViewModel())
    }
}
