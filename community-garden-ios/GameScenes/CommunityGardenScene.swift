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
    
    var parcels: [Parcel] = []
    var soils: [Soil] = []
    
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
        
        // TODO: Remove number of parcels hardcoding
        addParcelsToColumn(firstColumn, count: 4)
        addParcelsToColumn(secondColumn, count: 4)
        addTreesToParcels()
        addSoilsToParcels()
        addFlowersToSoils()
        
        
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
    
    func addSoilsToParcels(){
        for i in 0...parcels.count-1 {
            if i % 2 == 0 {
                addHorizontalSoil(parcel: &parcels[i])
            } else {
                addVerticalSoil(parcel: &parcels[i])
                
            }
        }
    }
    
    func addFlowersToSoils(){
        guard soils.count != 0 else { return }
        
        let flowers = getFlowerNodes()
        
        // counters
        var soilCounter = 0
        var flowerCounter = 0
        
        // add to soils array
        while flowerCounter < flowers.count {
            if soils[soilCounter].isFull {
                soilCounter += 1
                continue
            }
            
            flowers[flowerCounter].name = soils[soilCounter].node.name
            soils[soilCounter].flowers.append(flowers[flowerCounter])
            soilCounter += 1
            flowerCounter += 1
            
            // check if all soils are full
            if flowerCounter + 1 == soils.count * 4 { break }
            
            if soilCounter == soils.endIndex { soilCounter = 0 }
        }
                
        // attach flower nodes to soils
        for soil in soils {
            let soilWidth = soil.alignment == .horizontal ?  soil.node.size.width : soil.node.size.height
            let spacing = soilWidth / 4
            
            var xStart = -soilWidth / 2 + 10
            var yStart = -10.0
                                    
            for flower in soil.flowers {
                if soil.alignment == .horizontal {
                    flower.position = CGPoint(x: xStart, y: 0)
                    xStart += spacing
                } else {
                    flower.position = CGPoint(x: 0, y: yStart)
                    yStart -= spacing
                }
                soil.node.addChild(flower)
            }
        }
    }
    
    
    // MARK: Helper methods
    func getFlowerNodes() -> [SKSpriteNode]{
        guard let group = communityViewModel.group else { return [] }
        
        let mapping = [
            0: "abyss-sage",
            1: "savage-morel",
            2: "joyful-clover"
        ]
        
        let flowers = group.flowers
        var flowerNodes: [SKSpriteNode] = []
        
        for color in flowers.keys {
            if let flowersArr = flowers[color] {
                for i in 0...flowersArr.count-1 {
                    let numFlower = flowersArr[i]
                    if numFlower > 0 {
                        for _ in 1...numFlower {
                            let flower = color + "-" + mapping[i]!
                            let nodeFlower = SKSpriteNode(imageNamed: "flowers/\(flower)")
                            nodeFlower.anchorPoint = CGPoint(x:0.5, y:0)
                            nodeFlower.setScale(0.07)
                            nodeFlower.zPosition = 6
                            flowerNodes.append(nodeFlower)
                        }
                    }
                }
            }
        }
        
        return flowerNodes
    }
    
    func addHorizontalSoil(parcel: inout Parcel){
        guard let tree = parcel.tree else { return }
        let offset = parcel.node.size.height * 0.085
        var yPosition = tree.position.y + offset
        
        // create soils
        parcel.soils.append(Soil(node:SKSpriteNode(imageNamed: "soil-horizontal"), alignment: SoilAlignment.horizontal))
        parcel.soils.append(Soil(node:SKSpriteNode(imageNamed: "soil-horizontal"), alignment: SoilAlignment.horizontal))
        
        for soil in parcel.soils {
            soil.node.name = parcel.node.name
            soil.node.position = CGPoint(x: 0, y: -yPosition)
            soil.node.size.width = parcel.node.size.width * 0.8
            yPosition += soil.node.size.height + offset
            parcel.node.addChild(soil.node)
            soils.append(soil)
        }
    }
    
    func addVerticalSoil(parcel: inout Parcel){
        guard parcel.tree != nil else { return }
        
        // create soils
        parcel.soils.append(Soil(node:SKSpriteNode(), alignment: SoilAlignment.vertical))
        parcel.soils.append(Soil(node:SKSpriteNode(), alignment: SoilAlignment.vertical))
        
        let soilLeft = parcel.soils[0]
        let soilRight = parcel.soils[1]
        let parcelHeight = parcel.node.size.height
        
        soilLeft.node.size.height = parcel.node.size.height / 2
        soilRight.node.size.height = parcel.node.size.height / 2
        
        soilLeft.node.name = parcel.node.name
        soilRight.node.name = parcel.node.name
        
        soils.append(soilLeft)
        soils.append(soilRight)

        let xOffset = parcel.node.size.width * 0.4
        let yOffset: CGFloat = 10
        
        // change anchor point
        soilLeft.node.anchorPoint = CGPoint(x: 0.5, y: 1)
        soilRight.node.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        // place soils
        soilLeft.node.position = CGPoint(x:  -1 * xOffset , y: parcelHeight / 2 - yOffset)
        soilRight.node.position = CGPoint(x: xOffset, y: parcelHeight / 2 - yOffset)
        
        // add soils to parcel
        parcel.node.addChild(soilLeft.node)
        parcel.node.addChild(soilRight.node)
    }
    
    func addTree(tree: GardenItem, parcel: inout Parcel, zPosition: CGFloat = 5.0){
        
        // parcel
        parcel.node.name = tree.userID
        parcel.board.name = tree.userID
        
        // Tree
        let treeNode = SKSpriteNode(imageNamed: tree.name)
        treeNode.name = tree.userID
        treeNode.zPosition = zPosition
        treeNode.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        let grassLocation = CGPoint(x: treeNode.position.x - 15, y: treeNode.position.y)
        let _ = SceneHelper.addGrass(scene: self, location: grassLocation)
        
        
        treeNode.setScale(tree.scale * 0.5)
//        let treeAction = SKAction.scale(to: tree.scale * 0.5, duration: SCALE_DURATION)
//        treeNode.run(treeAction)
        
        // grass
        let grassNode = SKSpriteNode(imageNamed: "grass2")
        grassNode.position = CGPoint(x: -10, y: 0)
        // grassNode.setScale(tree.scale * 0.1)
        
        
        // label
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.name = parcel.node.name
        label.text = tree.gardenName
        label.fontSize = 13
        label.fontColor = UIColor(Color.oldCopper)
        
        treeNode.addChild(grassNode)
        
        parcel.tree = treeNode
        parcel.board.addChild(label)
        parcel.node.addChild(treeNode)
    }
    
}
