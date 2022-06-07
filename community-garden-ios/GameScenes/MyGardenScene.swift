//
//  SampleScene.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 5/6/22.
//

import SpriteKit

enum CollisionTypes: UInt32 {
    case tree = 1
    case droplet = 2
}

enum NodeNames: String {
    case tree = "tree"
    case droplet = "droplet"
}

class MyGardenScene: SKScene, SKPhysicsContactDelegate {
    
    let TREE_SCALE_FACTOR = 0.03
    let SCALE_DURATION = 2.5
    
    var tree: SKSpriteNode!
    var dropletSound: SKAudioNode!
    var gameTimer: Timer?
    
    let userViewModel = UserViewModel.shared
    
    var clouds = ["cloud1", "cloud2"]
    var dropletSoundEffect: SKAudioNode!
    
    
    
    var dropletNums = UserService.shared.user.numDroplets
    
    
    override func didMove(to view: SKView) {
        
       // Background
        self.backgroundColor = .clear
        let treeTexture = SKTexture(imageNamed: "oak")
        tree = SKSpriteNode(texture: treeTexture)

        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self


        // Tree
        tree.anchorPoint = CGPoint(x:0.5, y: 0)
        tree.position = CGPoint(x: frame.midX, y:0)
        tree.name = NodeNames.tree.rawValue
//
//
//        let physicsBodySize = CGSize(width: tree.size.width, height: tree.size.height * 2)
//        tree.physicsBody = SKPhysicsBody(texture: treeTexture, size: physicsBodySize)
//        tree.physicsBody?.categoryBitMask = CollisionTypes.tree.rawValue
//        tree.physicsBody?.contactTestBitMask = CollisionTypes.droplet.rawValue
//        tree.physicsBody?.isDynamic = false
//
//        let treeHeight = CGFloat(UserService.shared.user.gardenItems[0].height)
//        tree.setScale(0)
//        let treeAction = SKAction.scale(to: treeHeight, duration: SCALE_DURATION)
//        tree.run(treeAction)
//        addChild(tree)
//
//        // Timer
//        gameTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(createCloud), userInfo: nil, repeats: true)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x > frame.maxX {
                node.removeFromParent()
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        releaseDroplet(position: location)
    }
    
    
    func releaseDroplet(position: CGPoint){
        
        print(UserService.shared.user.numDroplets)
        guard UserService.shared.user.numDroplets > 0 else { return }
        
        let droplet = SKSpriteNode(imageNamed: "droplet")
        droplet.position = position
        droplet.setScale(0.55)
        droplet.physicsBody = SKPhysicsBody(circleOfRadius: droplet.size.width / 2)
        droplet.physicsBody?.categoryBitMask = CollisionTypes.droplet.rawValue
        droplet.physicsBody?.contactTestBitMask = CollisionTypes.tree.rawValue
        
        droplet.name = NodeNames.droplet.rawValue
        addChild(droplet)
        
        GardenViewModel.shared.handleDropletRelease()
    }
    
    
    @objc func createCloud() {
        
        guard let selectedImage = clouds.randomElement() else { return }
        
        let cloud = SKSpriteNode(imageNamed: selectedImage)
        
        
        cloud.setScale(0.5)
        cloud.anchorPoint = CGPoint(x: 0, y: 0.5)
        let randomPosition = CGPoint(x: Int(-cloud.size.width), y: Int.random(in: Int(frame.midY)...Int(frame.maxY)))
        
        let moveCloudAction = SKAction.moveTo(x: frame.maxX, duration: 10.0)
        let actionRepeat = SKAction.repeatForever(moveCloudAction)
        
        cloud.position = randomPosition
        cloud.alpha = 0.5
        cloud.zPosition = -1
        cloud.run(actionRepeat)
        
        addChild(cloud)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == NodeNames.droplet.rawValue && nodeB.name == NodeNames.tree.rawValue {
            handleCollision(droplet: nodeA)
        } else if nodeB.name == NodeNames.droplet.rawValue && nodeA.name == NodeNames.tree.rawValue{
            handleCollision(droplet: nodeB)
        } else if nodeB.name == NodeNames.droplet.rawValue {
            nodeB.removeFromParent()
        } else if nodeA.name == NodeNames.droplet.rawValue {
            nodeB.removeFromParent()
        }
    }
    
    func handleCollision(droplet: SKNode){
        let treeHeight = CGFloat(UserService.shared.user.gardenItems[0].height) + TREE_SCALE_FACTOR
        let treeAction = SKAction.scale(to: treeHeight, duration: SCALE_DURATION)
        tree.run(treeAction)
        droplet.removeFromParent()
    }
}
