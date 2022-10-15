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
    var gameTimer2: Timer?

    var havePlacedFlowers = false
    var validPositions: [String: CGPoint] = [:]
    
    // Nodes
    let firstColumn: SKSpriteNode = SKSpriteNode()
    let secondColumn: SKSpriteNode = SKSpriteNode()
    var plots: [SKSpriteNode] = []
    var parcels: [Parcel] = []
    
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
        gameTimer2 = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(createCloud), userInfo: nil, repeats: true)

        
        
        // Setting up scene elements
        
//        let plot = SKSpriteNode(imageNamed: "plot")
//        let x = plot.size.width
//        let y = plot.size.height
        
//        let xOffset: CGFloat = 35

        
//        let firstColumnBoardPosition = CGPoint(x: -x/2 + xOffset, y: y/2)
//        let secondColumnBoardPosition = CGPoint(x: x/2 - xOffset, y: -y/2)
        
//        let numPlotsPerColumn: Int = Int(ceil(Double(communityViewModel.trees.count) / 2))
                
        
        addParcelsToColumn(firstColumn, count: 4)
        addParcelsToColumn(secondColumn, count: 4)
        addTreesToParcels()
        addSoilsToParcels()
//        adddFlowersToParcels()

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

    func addParcelsToColumn(_ column: SKSpriteNode, count: Int){
        
        guard count != 0 else { return }
        
        let width = frame.width * 0.5
        let height = frame.height * 0.25
        var yPosition: CGFloat = 0
                        
        for _ in 1...count {
            // cell
            let cell = SKSpriteNode()
            cell.size = CGSize(width: width, height: height)
                    
            cell.anchorPoint = CGPoint(x: 0, y: 1)
            cell.position = CGPoint(x: 0, y: -yPosition)
            
            // plot
            let plot = SKSpriteNode(imageNamed: "plot")
            plot.position = CGPoint(x: cell.size.width / 2 , y: -cell.size.height / 2)
            plot.size.height = height * 0.8
            plot.size.width = width * 0.8
            
            // board
            let board = SKSpriteNode(imageNamed: "board")
            board.position = CGPoint(x: 0, y: -plot.size.height / 2)
            board.setScale(plot.size.width * 0.006)
//            board.zRotation = .pi / 8

            plot.addChild(board)
            cell.addChild(plot)
            column.addChild(cell)
            
            let parcel = Parcel(node: plot, board: board)
            parcels.append(parcel)
            yPosition = yPosition + height
        }
    }
    
    func addTreesToParcels(){
        var counter = 0
        for tree in communityViewModel.trees {
            addTree(tree: tree, parcel: &parcels[counter])
            counter += 1
        }
    }
    
    func adddFlowersToParcels(){
        guard let group = communityViewModel.group else { return }

        let mapping = [
            0: "abyss-sage",
            1: "savage-morel",
            2: "joyful-clover"
        ]

        let flowers = group.flowers
        var parcelIndex = 0

        for color in flowers.keys {
            if let flowersArr = flowers[color] {
                for i in 0...flowersArr.count-1 {
                    let numFlower = flowersArr[i]
                    if numFlower > 0 {
                        for _ in 1...numFlower {
                            let flower = color + "-" + mapping[i]!
                            let nodeFlower = SKSpriteNode(imageNamed: flower)
                            guard var currentSoil = parcels[parcelIndex].currentSoil else { continue }
                            currentSoil.flowers.append(nodeFlower)
                            parcelIndex += 1
                            if parcelIndex == parcels.endIndex {
                                parcelIndex = 0
                            }
                        }
                    }
                }
            }
        }
    }
    
    func addSoilsToParcels(){
        for i in 0...parcels.count-1 {
            if i % 2 == 0 {
                addSoilOne(parcel: parcels[i])
            } else {
                addSoilTwo(parcel: parcels[i])

            }
        }
    }
    
    // MARK: Helper methods
    func addSoilOne(parcel: Parcel){
        guard let tree = parcel.tree else { return }
        let offset = parcel.node.size.height * 0.085
        var yPosition = tree.position.y + offset
        
        for soil in parcel.soils {
            soil.node.position = CGPoint(x: 0, y: -yPosition)
            soil.node.size.width = parcel.node.size.width * 0.8
            yPosition += soil.node.size.height + offset
            
            // show flowers
            for i in 0...soil.flowers.count-1 {
                addFlower(&soil.flowers[i], soil: soil)
                soil.node.addChild(soil.flowers[i])
            }
            
            parcel.node.addChild(soil.node)
        }
    }
    
    func addSoilTwo(parcel: Parcel){
        guard parcel.tree != nil else { return }
        
        let soilLeft = parcel.soils[0]
        let soilRight = parcel.soils[1]
        
        let xOffset = parcel.node.size.width * 0.35
        
        // change width
        soilLeft.node.size.width = parcel.node.size.height * 0.8
        soilRight.node.size.width = parcel.node.size.height * 0.8
        
        // rotate soil
        soilLeft.node.zRotation = (-1 * .pi) / 2
        soilRight.node.zRotation = .pi / 2
        
        // place soils
        soilLeft.node.position = CGPoint(x:  -1 * xOffset , y: 0)
        soilRight.node.position = CGPoint(x: xOffset, y: 0)
        
        // add soils to parcel
        parcel.node.addChild(soilLeft.node)
        parcel.node.addChild(soilRight.node)
    }
    
    func addFlower(_ flower: inout SKSpriteNode, soil: Soil ){
        
        // Four flowers per soil
        let spacing = soil.node.size.width / 4
        
        flower.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        if let lastFlower = soil.lastFlower {
            flower.position = CGPoint(x: lastFlower.position.x + spacing, y: 0)
        } else {
            flower.position = CGPoint(x: 0: spacing, y: 0)
        }
        
        
        
//        let node = SKSpriteNode(imageNamed: "flowers/\(flowerName)")
//        node.anchorPoint = CGPoint(x: 0, y: 0)
//
//        let x = parcel.node.size.width / 2
//        let y = parcel.node.size.height / 2
//
//        let offset: CGFloat = 10
//        let randomX = getRandomCGFloat(-1 * x + offset, x - offset)
//        let randomY = getRandomCGFloat(-1 * y + offset, y - offset)
//
//        node.position = CGPoint(x: randomX, y: randomY)
//        node.colorBlendFactor = getRandomCGFloat(0, 0.2)
//        node.zPosition = 1
//        node.setScale(0)
//        let action = SKAction.scale(to: 0.075, duration: SCALE_DURATION)
//        node.run(action)
//
//        parcel.node.addChild(node)
    }

    func addTree(tree: GardenItem, parcel: inout Parcel, zPosition: CGFloat = 5.0){
        // Tree
        let treeNode = SKSpriteNode(imageNamed: tree.name)
        treeNode.name = tree.userID
        treeNode.zPosition = zPosition
        treeNode.anchorPoint = CGPoint(x: 0.5, y: 0)
                
        let grassLocation = CGPoint(x: treeNode.position.x - 15, y: treeNode.position.y)
        let _ = SceneHelper.addGrass(scene: self, location: grassLocation)
        
        treeNode.setScale(tree.scale * 0.3)
        
        treeNode.setScale(0)
        let treeAction = SKAction.scale(to: tree.scale * 0.5, duration: SCALE_DURATION)
        treeNode.run(treeAction)
        
        // grass
        let grassNode = SKSpriteNode(imageNamed: "grass2")
        grassNode.position = CGPoint(x: -10, y: 0)
//        grassNode.setScale(tree.scale * 0.1)
        
        
        // label
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = tree.gardenName
        label.fontSize = 13
        label.fontColor = UIColor(Color.oldCopper)
        
        treeNode.addChild(grassNode)
        
        parcel.tree = treeNode
        parcel.board.addChild(label)
        parcel.node.addChild(treeNode)
    }
    
    
}
