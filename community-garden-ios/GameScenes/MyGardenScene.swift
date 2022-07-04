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
    case ground = 4
    case grass = 8
}

enum NodeNames: String {
    case tree = "tree"
    case droplet = "droplet"
    case ground = "ground"
    case grass = "grass"
}

class MyGardenScene: SKScene, SKPhysicsContactDelegate {
    
    let TREE_SCALE_FACTOR = 0.03
    let SCALE_DURATION = 2.5
    let userDefaults = UserDefaultsService.shared
    
    // Defaults
    var DEFAULT_TREE: String {
        userDefaults.get(key: UserDefaultsKey.TREE) ?? "spiky-maple"
    }
    
    var tree: SKSpriteNode!
    var ground: SKSpriteNode!
    var dropletSound: SKAudioNode!
    var gameTimer: Timer?
    
    var clouds = ["cloud1", "cloud2"]
    var dropletSoundEffect: SKAudioNode!
    
    // ViewModels
    let userViewModel = UserViewModel.shared
    
    var dropletNums = UserService.shared.user.numDroplets
    
    override func didMove(to view: SKView) {
        
        // Game Scene
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        // Background
        self.backgroundColor = .clear
        
        // Scene setup
        ground = setupGround()
        let _ = setupTree(ground: ground)
        
        // Timer
        gameTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(createCloud), userInfo: nil, repeats: true)
        
    }
    
    func setupGround() -> SKSpriteNode {
        let groundTexture = SKTexture(imageNamed: "ground")
        let ground = SKSpriteNode(texture: groundTexture)
        
        ground.anchorPoint = CGPoint(x: 0, y:0)
        ground.position = CGPoint(x: 0, y:0)
        ground.size = CGSize(width: frame.width, height: ground.size.height)
        ground.name = NodeNames.ground.rawValue
        
        let groundPhysicsBodySize = CGSize(width: ground.size.width * 2, height: ground.size.height)
        ground.physicsBody = SKPhysicsBody(texture: groundTexture, size: groundPhysicsBodySize)
        ground.physicsBody?.categoryBitMask = CollisionTypes.ground.rawValue
        ground.physicsBody?.contactTestBitMask = CollisionTypes.droplet.rawValue
        ground.physicsBody?.isDynamic = false
        
        addChild(ground)
        return ground
    }
    
    func setupTree(ground: SKSpriteNode) -> SKSpriteNode{
        // Tree
        let treeTexture = SKTexture(imageNamed: "sunglow-\(DEFAULT_TREE)")
        tree = SKSpriteNode(texture: treeTexture)
        tree.anchorPoint = CGPoint(x:0.5, y: 0)
        tree.position = CGPoint(x: frame.midX, y: ground.size.height / 2)
        tree.name = NodeNames.tree.rawValue
        //tree.setScale(1.5)
        
        let physicsBodySize = CGSize(width: tree.size.width, height: tree.size.height * 2)
        tree.physicsBody = SKPhysicsBody(texture: treeTexture, size: physicsBodySize)
        tree.physicsBody?.categoryBitMask = CollisionTypes.tree.rawValue
        tree.physicsBody?.contactTestBitMask = CollisionTypes.droplet.rawValue
        tree.physicsBody?.isDynamic = false
        
        //let treeHeight = CGFloat(UserService.shared.user.gardenItems[0].height)
        tree.setScale(1.20)
        let treeAction = SKAction.scale(to: 1.20, duration: SCALE_DURATION)
        tree.run(treeAction)
        addChild(tree)
        
        return tree
    }
    
    func createGrass(position: CGPoint) {
        // Garden Grass
        let grass = SKSpriteNode(imageNamed: "grass")
        grass.anchorPoint = CGPoint(x: 0, y: 0)
                
        grass.position = CGPoint(x: position.x, y: getRandomCGFloat(10, ground.size.height))
        grass.zPosition = 10
        grass.name = NodeNames.grass.rawValue
        grass.setScale(0)
        
        let grassAction = SKAction.scale(to: getRandomCGFloat(0.5, 1), duration: SCALE_DURATION)
        grass.run(grassAction)
        
        addChild(grass)
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
        
        guard UserService.shared.user.numDroplets > 0 else { return }
        
        let droplet = SKSpriteNode(imageNamed: "droplet")
        droplet.position = position
        droplet.setScale(0.55)
        droplet.physicsBody = SKPhysicsBody(circleOfRadius: droplet.size.width / 2)
        droplet.physicsBody?.categoryBitMask = CollisionTypes.droplet.rawValue
        droplet.physicsBody?.contactTestBitMask = CollisionTypes.tree.rawValue
        
        droplet.name = NodeNames.droplet.rawValue
        addChild(droplet)
        
        //GardenViewModel.shared.handleDropletRelease()
    }
    
    
    @objc func createCloud() {
        
        guard let selectedCloud = clouds.randomElement() else { return }
        let cloud = SKSpriteNode(imageNamed: selectedCloud)
        
        cloud.setScale(0.75)
        cloud.anchorPoint = CGPoint(x: 0, y: 0.5)
        let randomPosition = CGPoint(x: -cloud.size.width, y: getRandomCGFloat(frame.midY,frame.maxY))
        
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
        
        // Contact droplet + tree
        if nodeA.name == NodeNames.droplet.rawValue && nodeB.name == NodeNames.tree.rawValue {
            handleTreeDropletContact(droplet: nodeA)
        } else if nodeB.name == NodeNames.droplet.rawValue && nodeA.name == NodeNames.tree.rawValue{
            handleTreeDropletContact(droplet: nodeB)
            
        // Contact droplet + ground
        } else if(nodeA.name == NodeNames.droplet.rawValue && nodeB.name == NodeNames.ground.rawValue){
            handleGrassDropletContact(position: contact.contactPoint, droplet: nodeA)
        } else if(nodeA.name == NodeNames.ground.rawValue && nodeB.name == NodeNames.droplet.rawValue){
            handleGrassDropletContact(position: contact.contactPoint, droplet: nodeB)
        }
        
        // Others
        else if nodeB.name == NodeNames.droplet.rawValue {
            nodeB.removeFromParent()
        } else if nodeA.name == NodeNames.droplet.rawValue {
            nodeA.removeFromParent()
        }
    }
    
    func handleTreeDropletContact(droplet: SKNode){
//        let treeHeight = CGFloat(UserService.shared.user.gardenItems[0].height) + TREE_SCALE_FACTOR
//        let treeAction = SKAction.scale(to: treeHeight, duration: SCALE_DURATION)
//        tree.run(treeAction)
        droplet.removeFromParent()
    }
    
    func handleGrassDropletContact(position: CGPoint, droplet: SKNode){
        droplet.removeFromParent()
        createGrass(position: position)
    }
}
