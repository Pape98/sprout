//
//  SampleScene.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 5/6/22.
//

import SpriteKit

enum CollisionTypes: UInt32 {
    case tree = 1
    case ground = 2
    case dropItem = 4
}

enum NodeNames: String {
    case tree
    case droplet
    case ground
    case flower
    case seed
}

class MyGardenScene: SKScene, SKPhysicsContactDelegate {
    
    let TREE_SCALE_FACTOR = 0.25
    let SCALE_DURATION = 2.0
    let userDefaults = UserDefaultsService.shared
    
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
    
    // SKNode
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
    let gardenViewModel: GardenViewModel = GardenViewModel.shared
    
    // Others
    
    override func didMove(to view: SKView) {
        
        // Game Scene
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        // Background
        self.backgroundColor = .clear
        
        // Scene setup
        ground = SceneHelper.setupGround(scene: self)
        
        addExisitingItems()
        
        // Timer
        gameTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(createCloud), userInfo: nil, repeats: true)
        
    }
    
    // MARK: Flower methods
    func createNewFlower(position: CGPoint) {
        // Garden Flower
        let flower = SKSpriteNode(imageNamed: "flowers/\(FLOWER)")
        
        flower.anchorPoint = CGPoint(x: 0, y: 0)
        flower.position = CGPoint(x: position.x, y: getRandomCGFloat(5, ground.size.height * 0.7))

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
        
        let flowerItem = GardenItem(userID: UserService.user.id, type: GardenItemType.flower,
                                    name: FLOWER, x: x, y: y,
                                    scale: scale)
        
        gardenViewModel.addFlower(flowerItem)
    }
    
    func addExisitingItems(){
        for item in gardenViewModel.items {
            switch item.type {
            case .flower:
                SceneHelper.addExistingFlower(flower: item, scene: self)
            case .tree:
                SceneHelper.addTree(tree: item, ground: ground, scene: self)
            }
        }
    }
    
    // MARK: SKScene methods
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
        releaseDropItem(position: location)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        
        // Contact droplet + tree
        if nodeA.name == NodeNames.droplet.rawValue && nodeB.name == NodeNames.tree.rawValue {
            handleTreeDropletContact(droplet: nodeA)
        } else if nodeB.name == NodeNames.droplet.rawValue && nodeA.name == NodeNames.tree.rawValue{
            handleTreeDropletContact(droplet: nodeB)
            
        // Contact seed + ground
        } else if(nodeA.name == NodeNames.seed.rawValue && nodeB.name == NodeNames.ground.rawValue){
            handleFlowerSeedContact(position: contact.contactPoint, seed: nodeA)
        } else if(nodeA.name == NodeNames.ground.rawValue && nodeB.name == NodeNames.seed.rawValue){
            handleFlowerSeedContact(position: contact.contactPoint, seed: nodeB)
        }
        
        // Others
        else if nodeB.name == NodeNames.droplet.rawValue  || nodeB.name == NodeNames.seed.rawValue {
            nodeB.removeFromParent()
        } else if nodeA.name == NodeNames.droplet.rawValue || nodeB.name == NodeNames.seed.rawValue {
            nodeA.removeFromParent()
        }
    }
    
    
    // MARK: Garden item creation methods
    func releaseDropItem(position: CGPoint){
        let name = gardenViewModel.dropItem
        let droplet = SKSpriteNode(imageNamed: name.rawValue)
        droplet.position = position
        droplet.setScale(0.55)
        droplet.physicsBody = SKPhysicsBody(circleOfRadius: droplet.size.width / 2)
        droplet.physicsBody?.categoryBitMask = CollisionTypes.dropItem.rawValue
        
        if gardenViewModel.dropItem == GardenElement.droplet {
            droplet.physicsBody?.contactTestBitMask = CollisionTypes.tree.rawValue
        }
        
        droplet.name =  gardenViewModel.dropItem == GardenElement.droplet ? NodeNames.droplet.rawValue : NodeNames.seed.rawValue
        addChild(droplet)
    }
    
    @objc func createCloud(){
        SceneHelper.createCloud(scene: self)
    }
    
    // MARK: Utility methods
    func handleTreeDropletContact(droplet: SKNode){
        // Only increase height if less than max height
        if tree.size.height < growthBreakpoint && gardenViewModel.dropItem == GardenElement.droplet {
            let treeScale = tree.xScale + TREE_SCALE_FACTOR
            let treeAction = SKAction.scale(to: treeScale, duration: SCALE_DURATION)
            tree.run(treeAction)
            
            // Update tree object's scale
            gardenViewModel.tree?.scale = treeScale
        }
        droplet.removeFromParent()
    }
    
    func handleFlowerSeedContact(position: CGPoint, seed: SKNode){
        if gardenViewModel.dropItem == GardenElement.seed {
            createNewFlower(position: position)
        }
        seed.removeFromParent()
    }
    
}
