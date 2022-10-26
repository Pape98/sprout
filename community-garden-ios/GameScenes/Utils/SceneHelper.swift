//
//  SceneHelper.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 14/07/2022.
//

import Foundation
import SpriteKit

enum CollisionTypes: UInt32 {
    case tree = 1
    case ground = 2
    case dropItem = 4
    case pond = 8
}

enum NodeNames: String {
    case tree
    case droplet
    case ground
    case flower
    case seed
    case pond
    case shadow
}

class SceneHelper {
    
    // MARK: Properties
    static let clouds = ["cloud1", "cloud2"]
    
    // MARK: Methods
    static func addGrass(scene: SKScene, location: CGPoint) -> SKSpriteNode {
        let grassNode = SKSpriteNode(imageNamed: "grass")
        grassNode.position = location
        grassNode.setScale(0.35)
        grassNode.zPosition = 6
        
        scene.addChild(grassNode)
            
        return grassNode
    }
    
    
    @objc static func createCloud(scene: SKScene, scale: Double = 0.75, isCommunityView: Bool = false) {
        guard let selectedCloud = clouds.randomElement() else { return }
        let cloud = SKSpriteNode(imageNamed: selectedCloud)
        
        cloud.setScale(scale)
        cloud.anchorPoint = CGPoint(x: 0, y: 0.5)
        var randomPosition: CGPoint? = nil
                
        if isCommunityView {
            randomPosition = CGPoint(x: -cloud.size.width, y: -1 * getRandomCGFloat(0,scene.frame.height))
        } else {
            randomPosition = CGPoint(x: -cloud.size.width, y: getRandomCGFloat(scene.frame.size.height * 0.70 ,scene.frame.maxY))
        }
        
        let moveCloudAction = SKAction.moveTo(x: scene.frame.maxX, duration: 10.0)
        let actionRepeat = SKAction.repeatForever(moveCloudAction)
        
        cloud.position = randomPosition!
        cloud.alpha = 0.5
        cloud.zPosition = 20
        cloud.run(actionRepeat)
        
        scene.addChild(cloud)
    }
    
    static func getPulseAction(scale: CGFloat, scaleOffset: CGFloat, duration: CGFloat = 2.5) -> SKAction {
        let scaleUp = SKAction.scale(to: scale, duration: duration)
        let scaleDown = SKAction.scale(to: scale - scaleOffset, duration: duration)
        
        let scaleAction = SKAction.sequence([scaleDown,scaleUp])
        let repeatedScaleAction = SKAction.repeatForever(scaleAction)
        
        return repeatedScaleAction
    }
    
}
