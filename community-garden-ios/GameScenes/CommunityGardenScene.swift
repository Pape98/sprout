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
    let firstColumn: SKSpriteNode = SKSpriteNode()
    let secondColumn: SKSpriteNode = SKSpriteNode()
    var plots: [SKSpriteNode] = []
    
    // Positions nextYPosition
    var currYposition: CGFloat = 0
    
    // ViewModels
    let communityViewModel = CommunityViewModel.shared
    let messagesViewModel = MessagesViewModel.shared
    
    let SCALE_DURATION = 2.0
    
    override func didMove(to view: SKView) {
        
        // Positions
        anchorPoint = CGPoint(x: 0, y: 1)
        firstColumn.position = CGPointMake(0, 0)
        secondColumn.position = CGPointMake(frame.midX, 0)
                        
        // Background
        self.backgroundColor = .clear
        
        // Timer
        gameTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(createCloud), userInfo: nil, repeats: true)
        
        
        // Setting up scene elements
//        treePositions = initializeTreePositions()
//        setupTrees()
//        setupFlowers()
        
        addPlotsToColumn(firstColumn, count: 2)
        addPlotsToColumn(secondColumn, count: 2)
        addTreesToPlots()

        addChild(firstColumn)
        addChild(secondColumn)
    }
    
    override func update(_ currentTime: TimeInterval) {}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNodes = self.nodes(at: location)

            for node in touchedNodes {
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

    func addPlotsToColumn(_ column: SKSpriteNode, count: Int){
        
        let width = frame.width * 0.5
        let height = frame.height * 0.5
        var yPosition: CGFloat = 0
                        
        for _ in 1...count {
            let cell = SKSpriteNode()
            cell.size = CGSize(width: width, height: height)
                    
            cell.anchorPoint = CGPoint(x: 0, y: 1)
            cell.position = CGPoint(x: 0, y: -yPosition)
            
            let plot = SKSpriteNode(imageNamed: "plot")
            plot.position = CGPoint(x: cell.size.width / 2 , y: -cell.size.height / 2)
            plot.size.height = height * 0.75
            plot.size.width = width * 0.75
            
            cell.addChild(plot)
            column.addChild(cell)
            
            plots.append(plot)
            yPosition = yPosition + height
        }
    }
    
    func addTreesToPlots(){
        var plotCounter = 0
        for tree in communityViewModel.trees {
            let plot = plots[plotCounter]
            addTree(tree: tree, plot: plot)
            plotCounter += 1
        }
    }
    
//    func setupFlowers(){
//        guard let group = communityViewModel.group else { return }
//
//        let mapping = [
//            0: "abyss-sage",
//            1: "savage-morel",
//            2: "joyful-clover"
//        ]
//
//        let flowers = group.flowers
//        var positions = getFlowerPositions()
//        var positionIndex = 0
//
//        for color in flowers.keys {
//            if let flowersArr = flowers[color] {
//                for i in 0...flowersArr.count-1 {
//                    let numFlower = flowersArr[i]
//                    if numFlower > 0 {
//                        for _ in 1...numFlower {
//                            if positionIndex == positions.endIndex {
//                                positions = getFlowerPositions()
//                                positionIndex = 0
//                            }
//                            let flower = color + "-" + mapping[i]!
//                            addFlower(flower, position: positions[positionIndex])
//                            positionIndex += 1
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    // For communityView
//    func addFlower(_ flowerName: String, position: CGPoint){
//        let node = SKSpriteNode(imageNamed: "flowers/\(flowerName)")
//        node.anchorPoint = CGPoint(x: 0, y: 0)
//        node.position = position
//        node.colorBlendFactor = getRandomCGFloat(0, 0.2)
//        node.zPosition = 1
//        node.setScale(0)
//        let action = SKAction.scale(to: 0.08, duration: SCALE_DURATION)
//        node.run(action)
//
//        addChild(node)
//    }
//
    // For community view
    func addTree(tree: GardenItem, plot: SKSpriteNode, zPosition: CGFloat = 5.0){
        // Tree
        let treeNode = SKSpriteNode(imageNamed: tree.name)
        treeNode.position = position
        treeNode.name = tree.userID
        treeNode.zPosition = zPosition
        treeNode.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        let grassLocation = CGPoint(x: treeNode.position.x - 15, y: treeNode.position.y)
        let _ = SceneHelper.addGrass(scene: self, location: grassLocation)
        
        treeNode.setScale(tree.scale * 0.5)
        
        treeNode.setScale(0)
        let treeAction = SKAction.scale(to: tree.scale * 0.5, duration: SCALE_DURATION)
        treeNode.run(treeAction)
        
//        // Shadow
//        let shadowNode = SKSpriteNode(imageNamed: "shadow")
//        shadowNode.position = CGPoint(x: treeNode.position.x, y: treeNode.position.y)
//        shadowNode.setScale(tree.scale * 0.5)
//
//        // Label
//        let label = SKLabelNode(text: "Baloo")
//        label.position = CGPoint(x: shadowNode.position.x , y: shadowNode.position.y - 25)
//        label.text = tree.gardenName
//        label.color = UIColor.black
//        label.colorBlendFactor = 1;
//        label.fontSize = treeNode.size.width * 0.17
//
//        addChild(label)
//        addChild(shadowNode)
            
        plot.addChild(treeNode)
    }
    
    
}
