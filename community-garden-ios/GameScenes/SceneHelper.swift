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
}

class SceneHelper {
    
    // MARK: Properties
    static let TREE_SCALE_FACTOR = 0.25
    static let SCALE_DURATION = 2.0
    static let clouds = ["cloud1", "cloud2"]
    
    // MARK: Methods
    static func setupGround(scene: SKScene) -> SKSpriteNode {
        let groundTexture = SKTexture(imageNamed: "ground")
        let ground = SKSpriteNode(texture: groundTexture)
        
        ground.anchorPoint = CGPoint(x: 0, y:0)
        ground.position = CGPoint(x: 0, y:0)
        ground.size = CGSize(width: scene.frame.width, height: ground.size.height)
        ground.name = NodeNames.ground.rawValue
        
        let groundPhysicsBodySize = CGSize(width: ground.size.width * 2, height: ground.size.height)
        ground.physicsBody = SKPhysicsBody(texture: groundTexture, size: groundPhysicsBodySize)
        ground.physicsBody?.categoryBitMask = CollisionTypes.ground.rawValue
        ground.physicsBody?.contactTestBitMask = CollisionTypes.dropItem.rawValue
        ground.physicsBody?.isDynamic = false
        
        scene.addChild(ground)
        return ground
    }
    
    static func setupPond(scene: SKScene) -> SKSpriteNode{
        let pondTexture = SKTexture(imageNamed: "pond")
        let pond = SKSpriteNode(texture: pondTexture)
        
        pond.anchorPoint = CGPoint(x: 0, y:0)
        pond.position = CGPoint(x: -20, y:0)
        pond.name = NodeNames.pond.rawValue
        
        let pondPhysicsBodySize = CGSize(width: pond.size.width * 2, height: pond.size.height * 2)
        pond.physicsBody = SKPhysicsBody(texture: pondTexture, size: pondPhysicsBodySize)
        pond.physicsBody?.categoryBitMask = CollisionTypes.pond.rawValue
        pond.physicsBody?.contactTestBitMask = CollisionTypes.dropItem.rawValue
        pond.physicsBody?.isDynamic = false
        
        scene.addChild(pond)
        
        return pond
    }
    
    static func addGrass(scene: SKScene, location: CGPoint) -> SKSpriteNode {
        let grassNode = SKSpriteNode(imageNamed: "grass")
        grassNode.position = location
        grassNode.setScale(0.35)
        grassNode.zPosition = 6
        
        scene.addChild(grassNode)
            
        return grassNode
    }
    
    static func addExistingFlower(flower: GardenItem, scene: SKScene, isAnimated: Bool = true){
        let node = SKSpriteNode(imageNamed: "flowers/\(flower.name)")
        node.anchorPoint = CGPoint(x: 0, y: 0)
        node.position = CGPoint(x: flower.x * scene.frame.width, y: flower.y * scene.frame.height)
        node.colorBlendFactor = getRandomCGFloat(0, 0.2)
        node.zPosition = 10
        node.setScale(flower.scale)
        
        // Animation
        if isAnimated {
            node.setScale(0)
            let nodeAction = SKAction.scale(to: flower.scale, duration: SCALE_DURATION)
            node.run(nodeAction)
        }
        
        scene.addChild(node)
    }
    
    
    @objc static func createCloud(scene: SKScene, scale: Double = 0.75, isCommunityView: Bool = false) {
        guard let selectedCloud = clouds.randomElement() else { return }
        let cloud = SKSpriteNode(imageNamed: selectedCloud)
        
        cloud.setScale(scale)
        cloud.anchorPoint = CGPoint(x: 0, y: 0.5)
        var randomPosition = CGPoint(x: -cloud.size.width, y: getRandomCGFloat(scene.frame.midY+20,scene.frame.maxY))
        
        if isCommunityView {
            randomPosition = CGPoint(x: -cloud.size.width, y: getRandomCGFloat(0,scene.frame.size.height))
        }
        
        let moveCloudAction = SKAction.moveTo(x: scene.frame.maxX, duration: 10.0)
        let actionRepeat = SKAction.repeatForever(moveCloudAction)
        
        cloud.position = randomPosition
        cloud.alpha = 0.5
        cloud.zPosition = 20
        cloud.run(actionRepeat)
        
        scene.addChild(cloud)
    }
    
}
