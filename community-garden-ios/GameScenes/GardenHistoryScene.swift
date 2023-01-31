//
//  GardenHistoryScene.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 10/31/22.
//

import Foundation
import SpriteKit

class GardenHistoryScene: SKScene {
    
    var ground: SKSpriteNode!
    var gameTimer: Timer?
    let SCALE_DURATION = 2.0
    
    // ViewModels
    let dataHistoryViewModel: DataHistoryViewModel = DataHistoryViewModel.shared
    let appViewModel: AppViewModel = AppViewModel.shared
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .clear
        ground = SceneHelper.setupGround(scene: self)
        addExisitingTreeFlowers()
        
        if appViewModel.isBadgeUnlocked(UnlockableBadge.cloud) {
            gameTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(createCloud), userInfo: nil, repeats: true)
        }
        
    }
    
    
    @objc func createCloud(){
        SceneHelper.createCloud(scene: self)
    }
    
    func addExisitingTreeFlowers(){
        for item in dataHistoryViewModel.historyItems {
            switch item.type {
            case .flower:
                SceneHelper.addExistingFlower(scene: self, flower: item)
            case .tree:
                addTree(tree: item, ground: ground)
            }
        }
    }
    
    func addTree(tree: GardenItem, ground: SKSpriteNode, isAnimated: Bool = true) {
        // Tree
        let treeTexture = SKTexture(imageNamed: tree.name)
        let treeNode = SKSpriteNode(texture: treeTexture)
        treeNode.anchorPoint = CGPoint(x:0.5, y: 0)
        
        if tree.y == 0 && tree.x == 0 {
            treeNode.position = CGPoint(x: frame.midX, y: ground.size.height / 2)
        } else {
            treeNode.position = CGPoint(x: tree.x, y: tree.y)
        }
        
        if isAnimated {
            treeNode.setScale(0)
            let treeAction = SKAction.scale(to: tree.scale, duration: SCALE_DURATION)
            treeNode.run(treeAction)
        }
        
        // Pulse action
        let pulseAction = SceneHelper.getPulseAction(scale: tree.scale, scaleOffset: 0.075)
        treeNode.run(pulseAction)
                
        addChild(treeNode)
        
        // shadow
        let shadowNode = SKSpriteNode(imageNamed: "shadow")
        shadowNode.zPosition = -tree.y - 10
        shadowNode.name = NodeNames.shadow.rawValue
        
        treeNode.addChild(shadowNode)
        
        // Grass
        let grassLocation = CGPoint(x: treeNode.position.x - 15, y: treeNode.position.y)
        let grassNode = SceneHelper.addGrass(scene: self, location: grassLocation)
        grassNode.zPosition = -treeNode.zPosition + 1
    }
}
