//
//  FriendGardenScene.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 5/24/22.
//

import Foundation
import SpriteKit

class FriendGardenScene: SKScene {
    
    var tree: SKSpriteNode!
    var ground: SKSpriteNode!
    var gameTimer: Timer?
    
    override func didMove(to view: SKView) {
        
        // Background
        self.backgroundColor = .clear
        
        // Ground
        ground = SceneHelper.setupGround(scene: self)
        
        // Tree
        let tree = GardenItem(userID: UserService.user.id, type: GardenItemType.tree, name: "cosmos-serpent-sumac", scale: 0.6)
        SceneHelper.addTree(tree: tree, ground: ground, scene: self)
        
        // Timer
        gameTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(createCloud), userInfo: nil, repeats: true)
    }
    
    @objc func createCloud(){
        SceneHelper.createCloud(scene: self, scale: 0.4)
    }
    
}
