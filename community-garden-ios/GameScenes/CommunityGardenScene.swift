//
//  CommunityGardenScene.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 17/09/2022.
//

import Foundation
import SpriteKit
import SwiftUI

class CommunityGardenScene: SKScene {
    var gameTimer: Timer?
    var havePlacedFlowers = false
    var validPositions: [String: CGPoint] = [:]
    
    // Nodes
    var leftFence: SKSpriteNode?
    var rightFence: SKSpriteNode?
    
    // ViewModels
    let communityViewModel = CommunityViewModel.shared
    let messagesViewModel = MessagesViewModel.shared
    
    var treePositions: [CGPoint]?
    //    let xOffset = 80.0
    //    let yOffset = 225.0
    
    
    override func didMove(to view: SKView) {
        
        // Background
        self.backgroundColor = .clear
        
        // Timer
        gameTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(createCloud), userInfo: nil, repeats: true)
        
        
        // Setting up scene elements
        leftFence = setupFence(location: CGPoint(x: 0, y:  frame.midY))
        rightFence = setupFence(location: CGPoint(x: frame.maxX, y:  frame.midY))
        treePositions = initializeTreePositions()
        setupTrees()
        setupFlowers()
    }
    
    override func update(_ currentTime: TimeInterval) {}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                
                guard let name = node.name else { return }
                guard let user = communityViewModel.members[name] else { return }
                
                messagesViewModel.showMessageOptionsSheet = true
                messagesViewModel.selectedUser = user
            }
        }
    }
    
    
    @objc func createCloud(){
        SceneHelper.createCloud(scene: self, scale: 0.45, isCommunityView: true)
    }
    
    func setupTrees(){
        var counter = 0
        //        var zIndex = 5
        
        for tree in communityViewModel.trees {
            let position = treePositions![counter]
            addTree(tree: tree, position: position)
            counter += 1
            
            // Get new Positions
            if counter == treePositions!.endIndex { return }
        }
    }
    
    func initializeTreePositions() -> [CGPoint]{
        
        let xOffset = 80.0
        
        let fenceOffset = (leftFence?.size.height)!/2
        // Bottom
        let bottomLeft = CGPoint(x: xOffset, y: frame.maxY * 1/4 - fenceOffset)
        let bottomRight = CGPoint(x: frame.maxX - xOffset, y: frame.maxY * 1/4 - fenceOffset)
        
        // Top
        let topLeft = CGPoint(x: xOffset, y: frame.height * 3/4)
        let topRight = CGPoint(x: frame.maxX - xOffset, y: frame.height * 3/4)
        
        
        return [topLeft,topRight,bottomLeft,bottomRight]
        
    }
    
    func setupFence(location: CGPoint, anchor: CGPoint? = nil) -> SKSpriteNode{
        let fence = SKSpriteNode(imageNamed: "fence")
        if anchor != nil { fence.anchorPoint = anchor! }
        fence.position = location
        addChild(fence)
        return fence
    }
    
    func setupFlowers(){
        guard let group = communityViewModel.group else { return }
        
        let mapping = [
            0: "abyss-sage",
            1: "savage-morel",
            2: "joyful-clover"
        ]
        
        let flowers = group.flowers
        var positions = getFlowerPositions()
        var positionIndex = 0
        
        for color in flowers.keys {
            if let flowersArr = flowers[color] {
                for i in 0...flowersArr.count-1 {
                    let numFlower = flowersArr[i]
                    if numFlower > 0 {
                        for _ in 1...numFlower {
                            if positionIndex == positions.endIndex {
                                positions = getFlowerPositions()
                                positionIndex = 0
                            }
                            let flower = color + "-" + mapping[i]!
                            addFlower(flower, position: positions[positionIndex])
                            positionIndex += 1
                        }
                    }
                }
            }
        }
    }
    
    func getFlowerPositions() -> [CGPoint] {
        let xOffset = 25.0
        let yOffset = 25.0
        
        // bottom
        let bl =  CGPoint(x: getRandomCGFloat(xOffset, frame.midX), y:getRandomCGFloat(0, frame.maxY * 1/4 - yOffset))
        let br =  CGPoint(x: getRandomCGFloat(frame.midX, frame.maxX - xOffset), y:getRandomCGFloat(0, frame.maxY * 1/4 - yOffset))
        
        // top
        let tl = CGPoint(x: getRandomCGFloat(xOffset, frame.midX), y: getRandomCGFloat(frame.midY + leftFence!.size.height / 2, frame.maxY * 3/4 - yOffset))
        let tr = CGPoint(x: getRandomCGFloat(frame.midX, frame.maxX - xOffset), y: getRandomCGFloat(frame.midY + leftFence!.size.height / 2, frame.maxY * 3/4 - yOffset))
        
        return [bl,br,tl,tr]
    }
    
    // For communityView
    func addFlower(_ flowerName: String, position: CGPoint){
        let node = SKSpriteNode(imageNamed: "flowers/\(flowerName)")
        node.anchorPoint = CGPoint(x: 0, y: 0)
        node.position = position
        node.colorBlendFactor = getRandomCGFloat(0, 0.2)
        //        node.zPosition = 7
        node.setScale(0.085)
        
        addChild(node)
    }
    
    // For community view
    func addTree(tree: GardenItem, position: CGPoint, zPosition: CGFloat = 5.0){
        // Tree
        let treeNode = SKSpriteNode(imageNamed: tree.name)
        treeNode.anchorPoint = CGPoint(x:0.5, y: 0)
        treeNode.position = position
        treeNode.name = tree.userID
        treeNode.zPosition = zPosition
        
        let grassLocation = CGPoint(x: treeNode.position.x - 15, y: treeNode.position.y)
        SceneHelper.addGrass(scene: self, location: grassLocation)
        
        treeNode.setScale(tree.scale * 0.5)
        
        // Label
        
        let label = SKLabelNode(text: "Baloo")
        let labely = treeNode.position.y + treeNode.size.height + 10
        label.position = CGPoint(x: treeNode.position.x , y: labely)
        label.text = tree.gardenName
        label.color = UIColor.darkText
        label.colorBlendFactor = 1;
        label.fontSize = treeNode.size.width * 0.17
        addChild(label)
        
        // Shadow
        let shadowNode = SKSpriteNode(imageNamed: "shadow")
        shadowNode.position = CGPoint(x: treeNode.position.x, y: treeNode.position.y)
        shadowNode.setScale(tree.scale * 0.5)
        
        addChild(shadowNode)
        addChild(treeNode)
    }
    
    
}
