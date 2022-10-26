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
    let appViewModel = AppViewModel.shared
    
    // Constants
    let SCALE_DURATION = 2.0    
    var NUM_PARCEL_PER_COLUMN: Int {
        let communityViewParams = RemoteConfiguration.shared.getConfigs(key: "communityViewParams")
        guard let communityViewParams = communityViewParams else { return 1 }
        return communityViewParams["numParcelPerColumn"] as! Int
    }
    
    override func didMove(to view: SKView) {
        
        // Positions
        anchorPoint = CGPoint(x: 0, y: 1)
        firstColumn.position = CGPointMake(0, 0)
        secondColumn.position = CGPointMake(frame.midX, 0)
        
        // Background
        self.backgroundColor = .clear
        
        // Timer
        if appViewModel.isBadgeUnlocked(UnlockableBadge.cloud) {
            gameTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(createCloud), userInfo: nil, repeats: true)
            gameTimer2 = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(createCloud), userInfo: nil, repeats: true)
        }
        
        // TODO: Remove number of parcels hardcoding
        addParcelsToColumn(firstColumn, count: NUM_PARCEL_PER_COLUMN, swap: true)
        addParcelsToColumn(secondColumn, count: NUM_PARCEL_PER_COLUMN)
        addTreesToParcels()
        addSoilsToParcels()
        addFlowersToSoils()
        
        
        addChild(firstColumn)
        addChild(secondColumn)
    }
    
    override func update(_ currentTime: TimeInterval) {}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    @objc func createCloud(){
        SceneHelper.createCloud(scene: self, scale: 0.45, isCommunityView: true)
    }
    
    func addParcelsToColumn(_ column: SKSpriteNode, count: Int, swap: Bool = false){
        
        guard count != 0 else { return }
        
        let width = frame.width * 0.5
        let height = frame.height * (1.0 / CGFloat(count))
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
            board.size.width = plot.size.width * 0.7
            
            // adding nodes to parents
            plot.addChild(board)
            cell.addChild(plot)
            column.addChild(cell)
            
            let parcel = Parcel(node: plot, board: board)
            parcels.append(parcel)
            yPosition = yPosition + height
        }
        
        if swap { swapParcels(&parcels) }
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
        let parcelHeight = parcel.node.size.height
        let parcelWidth = parcel.node.size.width
        
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
        
        // add pond
        if appViewModel.isBadgeUnlocked(UnlockableBadge.pond){
            let pondNode = SKSpriteNode(imageNamed: "pond\(getRandomNumber(1, 1))")
            pondNode.size = CGSize(width: parcelWidth * 0.8, height: parcelHeight * 0.35)
            pondNode.anchorPoint = CGPoint(x: 0.5, y: 0)
            pondNode.position = CGPoint(x: 0, y: parcelHeight * 0.1)
            parcel.node.addChild(pondNode)
        }
        
    }
    
    func addVerticalSoil(parcel: inout Parcel){
        guard parcel.tree != nil else { return }
        
        // create soils
        parcel.soils.append(Soil(node:SKSpriteNode(), alignment: SoilAlignment.vertical))
        parcel.soils.append(Soil(node:SKSpriteNode(), alignment: SoilAlignment.vertical))
        
        let soilLeft = parcel.soils[0]
        let soilRight = parcel.soils[1]
        
        soilLeft.node.size.height = parcel.node.size.height / 2
        soilRight.node.size.height = parcel.node.size.height / 2
        
        soilLeft.node.name = parcel.node.name
        soilRight.node.name = parcel.node.name
        
        soils.append(soilLeft)
        soils.append(soilRight)
        
        let xOffset = parcel.node.size.width * 0.4
        
        // place soils
        soilLeft.node.position = CGPoint(x:  -1 * xOffset , y: 0)
        soilRight.node.position = CGPoint(x: xOffset, y: 0)
        
        
        // add dog or turtle house
        let isDogHouseUnlocked = appViewModel.isBadgeUnlocked(UnlockableBadge.dogHouse)
        let isTurtleHouseUnlocked = appViewModel.isBadgeUnlocked(UnlockableBadge.turtleHouse)
        var houseNode = SKSpriteNode()
        
        if isDogHouseUnlocked || isTurtleHouseUnlocked {
            
            if isDogHouseUnlocked || isTurtleHouseUnlocked {
                let houses = ["dog-house-shadow", "turtle-house-shadow"]
                houseNode = SKSpriteNode(imageNamed: houses[getRandomNumber(0, 0)])
            } else if isDogHouseUnlocked {
                houseNode = SKSpriteNode(imageNamed: "dog-house-shadow")
            } else {
                houseNode = SKSpriteNode(imageNamed: "turtle-house-shadow")
            }
            houseNode.anchorPoint = CGPoint(x: 1, y: 0)
            houseNode.setScale(0.5)
            houseNode.position = CGPoint(x: parcel.node.size.width/2 - 10, y: parcel.node.size.width/2 + houseNode.size.height * 0.5)
            parcel.node.addChild(houseNode)
        }
        
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
        

        let treeScale = tree.scale * 0.4
        treeNode.setScale(treeScale)
        
        let pulseAction = SceneHelper.getPulseAction(scale: treeScale, scaleOffset: 0.05)
        
        treeNode.run(pulseAction)
        
        // shadow
        let shadowNode = SKSpriteNode(imageNamed: "shadow-community")
        shadowNode.zPosition = -1
        shadowNode.setScale(0.5)
        treeNode.addChild(shadowNode)
        
        // grass
        let grassNode = SKSpriteNode(imageNamed: "grass2")
        grassNode.position = CGPoint(x: -10, y: 0)
        // grassNode.setScale(tree.scale * 0.1)
        
        // label
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.name = parcel.node.name
        label.fontColor = UIColor(Color.oldCopper)
        label.text = tree.gardenName
        label.fontSize = 13
        
        parcel.board.size.width = label.frame.size.width + 10
        
        treeNode.addChild(grassNode)
        
        parcel.tree = treeNode
        parcel.board.addChild(label)
        parcel.node.addChild(treeNode)
    }
    
    func swapParcels(_ parcels: inout [Parcel]){
        var i = 0, j = 1
        
        while i < parcels.endIndex && j < parcels.endIndex {
            parcels.swapAt(i, j)
            i += 2
            j += 2
        }
    }
    
}
