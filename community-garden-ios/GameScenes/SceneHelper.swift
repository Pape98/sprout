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
    
    static func setupPond(scene: SKScene){
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
    }
    
    // For community view
    static func addTree(tree: GardenItem, scene: SKScene, position: CGPoint){
        // Tree
        let treeNode = SKSpriteNode(imageNamed: tree.name)
        treeNode.anchorPoint = CGPoint(x:0.5, y: 0)
        treeNode.position = position
        treeNode.name = NodeNames.tree.rawValue
        treeNode.zPosition = 5
        
        // Shadow
        let shadowNode = SKSpriteNode(imageNamed: "shadow")
        shadowNode.position = CGPoint(x: treeNode.position.x, y: treeNode.position.y)
        shadowNode.setScale(tree.scale * 0.6)
        
        let grassLocation = CGPoint(x: treeNode.position.x - 15, y: treeNode.position.y)
        addGrass(scene: scene, location: grassLocation)
        
        scene.addChild(shadowNode)
        scene.addChild(treeNode)
    }
    
    static func addTree(tree: GardenItem, ground: SKSpriteNode, scene: SKScene, isAnimated: Bool = true) -> SKSpriteNode {
        // Tree
        let treeTexture = SKTexture(imageNamed: tree.name)
        let treeNode = SKSpriteNode(texture: treeTexture)
        treeNode.anchorPoint = CGPoint(x:0.5, y: 0)
        treeNode.position = CGPoint(x: scene.frame.midX, y: ground.size.height / 2)
        treeNode.name = NodeNames.tree.rawValue
        treeNode.zPosition = 5
        
        let physicsBodySize = CGSize(width: treeNode.size.width, height: treeNode.size.height * 1.5)
        treeNode.physicsBody = SKPhysicsBody(texture: treeTexture, size: physicsBodySize)
        treeNode.physicsBody?.categoryBitMask = CollisionTypes.tree.rawValue
        treeNode.physicsBody?.contactTestBitMask = CollisionTypes.dropItem.rawValue
        treeNode.physicsBody?.isDynamic = false
        treeNode.setScale(tree.scale)
        
        if isAnimated {
            treeNode.setScale(0)
            let treeAction = SKAction.scale(to: tree.scale, duration: SCALE_DURATION)
            treeNode.run(treeAction)
        }
        
        scene.addChild(treeNode)
        
        // Grass
        let grassLocation = CGPoint(x: treeNode.position.x - 15, y: treeNode.position.y)
        addGrass(scene: scene, location: grassLocation)
        
        // Shadow
        let shadowNode = SKSpriteNode(imageNamed: "shadow")
        shadowNode.position = CGPoint(x: treeNode.position.x, y: treeNode.position.y)
        shadowNode.setScale(tree.scale)
        
        scene.addChild(shadowNode)
        
        return treeNode
    }
    
    static func addGrass(scene: SKScene, location: CGPoint){
        let grassNode = SKSpriteNode(imageNamed: "grass")
        grassNode.position = location
        grassNode.setScale(0.85)
        grassNode.zPosition = 6
        
        scene.addChild(grassNode)
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
