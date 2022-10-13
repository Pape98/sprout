//
//  SampleScene.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 5/6/22.
//

import SpriteKit
import AVFoundation

class MyGardenScene: SKScene, SKPhysicsContactDelegate {
    
    var TREE_SCALE_FACTOR: Double {
        let treeParams = RemoteConfiguration.shared.getTreeParams()!
        return treeParams["scaleFactor"]! as! Double
    }
    
    var TREE_MAX_SCALE: Double {
        let treeParams = RemoteConfiguration.shared.getTreeParams()!
        return treeParams["maxScale"]! as! Double
    }
    
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
    var grass: SKSpriteNode!
    var shadow: SKSpriteNode!
    var ground: SKSpriteNode!
    var pond: SKSpriteNode!
    
    var gameTimer: Timer?
    
    let clouds = ["cloud1", "cloud2"]
    
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
        
        pond = SceneHelper.setupPond(scene: self)
        
        addExisitingItems()
        
        // Timer
        gameTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(createCloud), userInfo: nil, repeats: true)
        
    }
    
    // MARK: Flower methods
    func createNewFlower(position: CGPoint) {
        
        // Check if position is valid
        if position.y > ground.size.height { return }
        if position.x < pond.position.x + pond.size.width + 10 { return }
        
        // Garden Flower
        let settings = UserService.shared.user.settings
        guard let settings = settings else { return }
        
        let flowerName = "\(settings.flowerColor)-\(addDash(settings.flower))"
        let flower = SKSpriteNode(imageNamed: "flowers/\(flowerName)")
        
        flower.anchorPoint = CGPoint(x: 0, y: 0)
        flower.position = CGPoint(x: position.x, y: position.y)
        
        flower.name = NodeNames.flower.rawValue
        flower.colorBlendFactor = getRandomCGFloat(0, 0.2)
        flower.setScale(0)
        flower.zPosition = 1
        
        let scale = 0.08
        let flowerAction = SKAction.scale(to: scale, duration: SCALE_DURATION)
        flower.run(flowerAction)
        
        addChild(flower)
        
        // Adding flower to firestore
        let x = flower.position.x / frame.maxX
        let y = flower.position.y / frame.maxY
        
        let flowerItem = GardenItem(userID: UserService.shared.user.id,
                                    type: GardenItemType.flower,
                                    name: flowerName, x: x, y: y,
                                    scale: scale,
                                    group: UserService.shared.user.group,
                                    gardenName: UserService.shared.user.settings!.gardenName,
                                    userName: UserService.shared.user.name
        )
        
        gardenViewModel.addFlower(flowerItem)
        gardenViewModel.decreaseNumSeeds()
    }
    
    func addExisitingItems(){
        for item in gardenViewModel.items {
            switch item.type {
            case .flower:
                SceneHelper.addExistingFlower(flower: item, scene: self)
            case .tree:
                let nodes = addTree(tree: item, ground: ground, scene: self)
                tree = nodes[0]
                grass = nodes[1]
                shadow = nodes[2]
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
        
        // Check if user has enough drop item and is in planting mode
        guard gardenViewModel.gardenMode == GardenViewModel.GardenMode.planting && gardenViewModel.hasEnoughDropItem() else { return }
        
        if gardenViewModel.dropItem == .droplet {
            releaseDropItem(position: location)
        } else {
            createNewFlower(position: location)
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gardenViewModel.gardenMode != GardenViewModel.GardenMode.moving { return }
        
        for touch in touches {
            let location = touch.location(in: self)
            // let nodes = self.nodes(at: location)
            
            guard tree != nil else { continue }
            guard grass != nil else { continue }
            guard shadow != nil else { continue }
        
            if isValidTreeLocation(location) == false { continue }
                        
            // NOTE: Can only move tree
            tree.position = location
            grass.position = CGPoint(x: tree.position.x - 15, y: tree.position.y)
            shadow.position = tree.position
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if isValidTreeLocation(location) == false { return }
        
        if gardenViewModel.tree != nil && gardenViewModel.gardenMode == GardenViewModel.GardenMode.moving {
            gardenViewModel.tree!.x = location.x
            gardenViewModel.tree!.y = location.y
            gardenViewModel.updateTree()

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
        
        // Case tree has reached max height for tree
        if gardenViewModel.dropItem == GardenElement.droplet && gardenViewModel.tree!.scale >= TREE_MAX_SCALE { return }
            
        let name = gardenViewModel.dropItem
        let dropItem = SKSpriteNode(imageNamed: name.rawValue)
        dropItem.position = position
        dropItem.setScale(0.50)
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
        }
    }
    
    @objc func createCloud(){
        SceneHelper.createCloud(scene: self)
    }
    
    func addTree(tree: GardenItem, ground: SKSpriteNode, scene: SKScene, isAnimated: Bool = true) -> [SKSpriteNode] {
        // Tree
        let treeTexture = SKTexture(imageNamed: tree.name)
        let treeNode = SKSpriteNode(texture: treeTexture)
        treeNode.anchorPoint = CGPoint(x:0.5, y: 0)
        
        if tree.y == 0 && tree.x == 0 {
            treeNode.position = CGPoint(x: scene.frame.midX, y: ground.size.height / 2)
        } else {
            treeNode.position = CGPoint(x: tree.x, y: tree.y)
        }
            
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
        let grassNode = SceneHelper.addGrass(scene: scene, location: grassLocation)
        
        // Shadow
        let shadowNode = SKSpriteNode(imageNamed: "shadow")
        shadowNode.position = CGPoint(x: treeNode.position.x, y: treeNode.position.y)
        shadowNode.setScale(tree.scale)
        
        scene.addChild(shadowNode)
        
        return [treeNode, grassNode, shadowNode]
    }
    
    // MARK: Utility methods
    func isValidTreeLocation(_ location: CGPoint) -> Bool {
        guard let ground = ground else { return false }
        guard let shadow = shadow else { return false }
        let yBoundary = ground.size.height - shadow.size.height/2
        let xBoundary = pond.size.width + 20
        
        if location.y >= yBoundary || location.y <= 20 { return false }
        else if location.x  <= xBoundary { return false }
        
        return true
    }
    
    func handleTreeDropletContact(droplet: SKNode){
        // Only increase height if less than max height
        if gardenViewModel.tree!.scale < TREE_MAX_SCALE && gardenViewModel.dropItem == GardenElement.droplet {
            var treeScale = gardenViewModel.tree!.scale + TREE_SCALE_FACTOR
            treeScale = round(treeScale * 1000) / 1000.0
       
            let treeAction = SKAction.scale(to: treeScale, duration: SCALE_DURATION)
            let shadowAction = SKAction.scale(to: treeScale, duration: SCALE_DURATION)
            tree.run(treeAction)
            shadow.run(shadowAction)
            
            // Update tree object's scale
            gardenViewModel.tree?.scale = treeScale
            gardenViewModel.updateTree()
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
