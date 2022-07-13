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
    case flower = 8
}

enum NodeNames: String {
    case tree = "tree"
    case droplet = "droplet"
    case ground = "ground"
    case flower = "flower"
}

class MyGardenScene: SKScene, SKPhysicsContactDelegate {
    
    let TREE_SCALE_FACTOR = 0.25
    let SCALE_DURATION = 2.0
    let userDefaults = UserDefaultsService.shared
    
    let gardenViewModel: GardenViewModel = GardenViewModel.shared
    
    // Defaults
    var TREE: String {
        let color = userDefaults.get(key: UserDefaultsKey.TREE_COLOR) ?? "cosmos"
        let tree = userDefaults.get(key: UserDefaultsKey.TREE) ?? "spiky-maple"
        return "\(color)-\(tree)"
    }
    
    var FLOWER: String {
        let color = userDefaults.get(key: UserDefaultsKey.FLOWER_COLOR) ?? "sunglow"
        let flower = userDefaults.get(key: UserDefaultsKey.FLOWER) ?? "abyss-sage"
        return "\(color)-\(flower)"
    }
    
    var tree: SKSpriteNode!
    var ground: SKSpriteNode!
    var dropletSound: SKAudioNode!
    var gameTimer: Timer?
    
    let clouds = ["cloud1", "cloud2"]
    // When to start/stop growing
    var growthBreakpoint: CGFloat {
        frame.midY * 0.8
    }
    var dropletSoundEffect: SKAudioNode!
    
    // ViewModels
    let userViewModel = UserViewModel.shared
    
    var dropletNums = 5
    
    override func didMove(to view: SKView) {
        
        // Game Scene
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        // Background
        self.backgroundColor = .clear
        
        // Scene setup
        ground = setupGround()
        let _ = setupTree(ground: ground)
        addExistingItems()
        
        // Timer
        gameTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(createCloud), userInfo: nil, repeats: true)
        
    }
    
    func addExistingItems(){
        addAllFlowers()
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
        let treeTexture = SKTexture(imageNamed: TREE)
        tree = SKSpriteNode(texture: treeTexture)
        tree.anchorPoint = CGPoint(x:0.5, y: 0)
        tree.position = CGPoint(x: frame.midX, y: ground.size.height / 2)
        tree.name = NodeNames.tree.rawValue
        
        let physicsBodySize = CGSize(width: tree.size.width, height: tree.size.height * 1.5)
        tree.physicsBody = SKPhysicsBody(texture: treeTexture, size: physicsBodySize)
        tree.physicsBody?.categoryBitMask = CollisionTypes.tree.rawValue
        tree.physicsBody?.contactTestBitMask = CollisionTypes.droplet.rawValue
        tree.physicsBody?.isDynamic = false
        
        tree.setScale(0)
        
        //        let treeHeight = CGFloat(UserService.shared.user.gardenItems[0].height)
        let treeAction = SKAction.scale(to: 1, duration: SCALE_DURATION)
        tree.run(treeAction)
        addChild(tree)
        
        return tree
    }
    
    func createNewFlower(position: CGPoint) {
        // Garden Flower
        let flower = SKSpriteNode(imageNamed: "flowers/\(FLOWER)")
        
        flower.anchorPoint = CGPoint(x: 0, y: 0)
        flower.position = CGPoint(x: position.x, y: getRandomCGFloat(5, ground.size.height * 0.7))
        flower.zPosition = 10
        flower.name = NodeNames.flower.rawValue
        flower.colorBlendFactor = getRandomCGFloat(0, 0.2)
        flower.setScale(0)
        let scale = getRandomCGFloat(0.075, 0.1)
        let flowerAction = SKAction.scale(to: scale, duration: SCALE_DURATION)
        flower.run(flowerAction)
        
        addChild(flower)
        
        // Adding flower to firestore
        let x = flower.position.x / frame.maxX
        let y = flower.position.y / frame.maxY
        
        let flowerItem = GardenItem(type: GardenItemType.flower,
                                    name: FLOWER, x: x, y: y, scale: scale)
        
        gardenViewModel.addFlower(flowerItem)
        
    }
    
    func addAllFlowers(){
        for item in gardenViewModel.items {
            if item.type == GardenItemType.flower {
                addExistingFlower(flower: item)
            }
        }
    }
    
    func addExistingFlower(flower: GardenItem){
        let node = SKSpriteNode(imageNamed: "flowers/\(flower.name)")
        node.anchorPoint = CGPoint(x: 0, y: 0)
        node.position = CGPoint(x: flower.x * frame.width, y: flower.y * frame.height)
        node.colorBlendFactor = getRandomCGFloat(0, 0.2)
        node.setScale(0)
        
        let nodeAction = SKAction.scale(to: flower.scale, duration: SCALE_DURATION)
        node.run(nodeAction)
        addChild(node)
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
        let droplet = SKSpriteNode(imageNamed: "droplet")
        droplet.position = position
        droplet.setScale(0.55)
        droplet.physicsBody = SKPhysicsBody(circleOfRadius: droplet.size.width / 2)
        droplet.physicsBody?.categoryBitMask = CollisionTypes.droplet.rawValue
        droplet.physicsBody?.contactTestBitMask = CollisionTypes.tree.rawValue
        
        droplet.name = NodeNames.droplet.rawValue
        addChild(droplet)
    }
    
    
    @objc func createCloud() {
        
        guard let selectedCloud = clouds.randomElement() else { return }
        let cloud = SKSpriteNode(imageNamed: selectedCloud)
        
        cloud.setScale(0.75)
        cloud.anchorPoint = CGPoint(x: 0, y: 0.5)
        let randomPosition = CGPoint(x: -cloud.size.width, y: getRandomCGFloat(frame.midY+20,frame.maxY))
        
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
            handleFlowerDropletContact(position: contact.contactPoint, droplet: nodeA)
        } else if(nodeA.name == NodeNames.ground.rawValue && nodeB.name == NodeNames.droplet.rawValue){
            handleFlowerDropletContact(position: contact.contactPoint, droplet: nodeB)
        }
        
        // Others
        else if nodeB.name == NodeNames.droplet.rawValue {
            nodeB.removeFromParent()
        } else if nodeA.name == NodeNames.droplet.rawValue {
            nodeA.removeFromParent()
        }
    }
    
    func handleTreeDropletContact(droplet: SKNode){
        // Only increase height if less than max height
        if tree.size.height < growthBreakpoint {
            let treeHeight = tree.xScale + TREE_SCALE_FACTOR
            let treeAction = SKAction.scale(to: treeHeight, duration: SCALE_DURATION)
            tree.run(treeAction)
        }
        droplet.removeFromParent()
    }
    
    func handleFlowerDropletContact(position: CGPoint, droplet: SKNode){
        // Create fower if tree is at max height
        if tree.size.height >= growthBreakpoint {
            createNewFlower(position: position)
        }
        droplet.removeFromParent()
    }
}
