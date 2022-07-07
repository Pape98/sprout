//
//  FriendGardenScene.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 5/24/22.
//

import Foundation
import SpriteKit

class FriendGardenScene: SKScene {
    
    var friend: User?
    var tree: SKSpriteNode!
    let SCALE_DURATION = 2.5
    
    override func didMove(to view: SKView) {
        
        // Background
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        // Tree
        let treeTexture = SKTexture(imageNamed: "tree1")
        tree = SKSpriteNode(texture: treeTexture)
        tree.anchorPoint = CGPoint(x:0.5, y: 0)
        tree.position = CGPoint(x: frame.midX, y:0)
        tree.name = NodeNames.tree.rawValue
        let treeHeight = 1.0
        tree.setScale(0)
        let treeAction = SKAction.scale(to: treeHeight, duration: SCALE_DURATION)
        tree.run(treeAction)
        addChild(tree)
        
    }
    
}
