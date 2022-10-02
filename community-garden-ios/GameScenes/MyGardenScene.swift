//
//  SampleScene.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 5/6/22.
//

import SpriteKit
import AVFoundation

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
    
    var gameTimer: Timer?
    
    let clouds = ["cloud1", "cloud2"]
    // When to start/stop growing
    var growthBreakpoint: CGFloat {
        frame.midY * 0.8
    }
    
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
        
        SceneHelper.setupPond(scene: self)
        
        addExisitingItems()
        
        // Timer
        gameTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(createCloud), userInfo: nil, repeats: true)
        
    }
    
    // MARK: Flower methods
    func createNewFlower(position: CGPoint) {
        // Garden Flower
        let settings = UserService.user.settings
        guard let settings = settings else { return }
        
        let flowerName = "\(settings.flowerColor)-\(addDash(settings.flower))"
        let flower = SKSpriteNode(imageNamed: "flowers/\(flowerName)")
        
        flower.anchorPoint = CGPoint(x: 0, y: 0)
        flower.position = CGPoint(x: position.x, y: getRandomCGFloat(5, ground.size.height * 0.7))
        
        flower.name = NodeNames.flower.rawValue
        flower.colorBlendFactor = getRandomCGFloat(0, 0.2)
        flower.setScale(0)
        flower.zPosition = 10
        
        let scale = 0.068
        let flowerAction = SKAction.scale(to: scale, duration: SCALE_DURATION)
        flower.run(flowerAction)
        
        addChild(flower)
        
        // Adding flower to firestore
        let x = flower.position.x / frame.maxX
        let y = flower.position.y / frame.maxY
        
        let flowerItem = GardenItem(userID: UserService.user.id, type: GardenItemType.flower,
                                    name: flowerName, x: x, y: y,
                                    scale: scale,
                                    group: UserService.user.group,
                                    gardenName: UserService.user.settings!.gardenName,
                                    userName: UserService.user.name
        )
        
        gardenViewModel.addFlower(flowerItem)
        
    }
    
    func addExisitingItems(){
        for item in gardenViewModel.items {
            switch item.type {
            case .flower:
                SceneHelper.addExistingFlower(flower: item, scene: self)
            case .tree:
                tree = SceneHelper.addTree(tree: item, ground: ground, scene: self)
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
                        
        if gardenViewModel.hasEnoughDropItem() {
            releaseDropItem(position: location)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        soundEffectHandler(nodeA)
        soundEffectHandler(nodeB)
        
        
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
        if nodeB.name == NodeNames.droplet.rawValue  || nodeB.name == NodeNames.seed.rawValue {
            nodeB.removeFromParent()
        } else if nodeA.name == NodeNames.droplet.rawValue || nodeA.name == NodeNames.seed.rawValue {
            nodeA.removeFromParent()
        }
    }
    
    
    // MARK: Garden item creation methods
    func releaseDropItem(position: CGPoint){
        let name = gardenViewModel.dropItem
        let dropItem = SKSpriteNode(imageNamed: name.rawValue)
        dropItem.position = position
        dropItem.setScale(0.55)
        dropItem.physicsBody = SKPhysicsBody(circleOfRadius: dropItem.size.width / 2)
        dropItem.physicsBody?.categoryBitMask = CollisionTypes.dropItem.rawValue
        
        if gardenViewModel.dropItem == GardenElement.droplet {
            dropItem.physicsBody?.contactTestBitMask = CollisionTypes.tree.rawValue
        }
        
        dropItem.name =  gardenViewModel.dropItem == GardenElement.droplet ? NodeNames.droplet.rawValue : NodeNames.seed.rawValue
        addChild(dropItem)
        
        // Update current drop item count
        if dropItem.name == GardenElement.droplet.rawValue {
            gardenViewModel.decreaseNumDroplets()
        } else {
            gardenViewModel.decreaseNumSeeds()
        }
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
            gardenViewModel.saveTreeScale()
        }
        
        droplet.removeFromParent()
    }
    
    func handleFlowerSeedContact(position: CGPoint, seed: SKNode){
        if gardenViewModel.dropItem == GardenElement.seed {
            createNewFlower(position: position)
        }
        seed.removeFromParent()
    }
    
    func soundEffectHandler(_ node:SKNode){
        
        switch(node.name) {
        case NodeNames.droplet.rawValue:
            AudioPlayer.shared.playCustomSound(filename: "water_droplet.mp3")
        case NodeNames.seed.rawValue:
            print("Playing seed")
        case .none:
            print("Cannot play audio")
        case .some(_): break
        }
    }
    
}
