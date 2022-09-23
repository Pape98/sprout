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
    var river : SKSpriteNode?
    var fence: SKSpriteNode?
            
    // ViewModels
    let communityViewModel = CommunityViewModel.shared
    let messagesViewModel = MessagesViewModel.shared
    
    
    override func didMove(to view: SKView) {
        
        // Background
        self.backgroundColor = .clear
        
        // Timer
        gameTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(createCloud), userInfo: nil, repeats: true)
        
        
        // Setting up scene elements
        river = setupRiver()
        fence = setupFence(location: CGPoint(x: 0, y: river!.position.y - 100), anchor: CGPoint(x: 0, y: 0))
        validPositions = initializeValidPositions()
        
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
        let positions = Array(validPositions.keys)
        for tree in communityViewModel.trees {
            let position = validPositions[positions[counter]]
            SceneHelper.addTree(tree: tree, scene: self, position: position!)
            counter += 1
            
            // Get new Positions
            if counter == 4 {
                validPositions = initializeValidPositions()
            }
        }
    }
    
    func setupRiver() -> SKSpriteNode {
        let river = SKSpriteNode(imageNamed: "river")
        river.position = CGPoint(x: frame.minX, y: frame.midY+40)
        river.zPosition = -5
        addChild(river)
        return river
    }
    
    func setupFence(location: CGPoint, anchor: CGPoint) -> SKSpriteNode{
        let fence = SKSpriteNode(imageNamed: "fence")
        fence.anchorPoint = anchor
        fence.position = location
        addChild(fence)
        return fence
    }
    
    func initializeValidPositions() -> [String: CGPoint]{
        
        let riverTop = river!.position.y + river!.size.height
        let fenceBottom = fence!.position.y
        
        let topLeft = CGPoint(x: getRandomCGFloat(40, frame.midX-50), y: getRandomCGFloat(riverTop, riverTop + 20))
        let topRight = CGPoint(x: getRandomCGFloat(frame.midX + 10, frame.maxX-70), y: getRandomCGFloat(riverTop, riverTop + 20))
        
        let bottomLeft = CGPoint(x: getRandomCGFloat(40, frame.midX-50), y: getRandomCGFloat(0, fenceBottom - 100))
        let bottomRight = CGPoint(x: getRandomCGFloat(frame.midX + 10, frame.maxX-50), y: getRandomCGFloat(0,fenceBottom - 100))
        
        return ["topLeft": topLeft,"topRight": topRight,"bottomLeft" : bottomLeft ,"bottomRight":bottomRight]
    }
    
    func setupFlowers(){
        guard let group = communityViewModel.group else { return }
                
        let mapping = [
            0: "abyss-sage",
            1: "savage-morel",
            2: "joyful-clover"
        ]
        
        let flowers = group.flowers
        
        validPositions = initializeValidPositions()
        let positionKeys = Array(validPositions.keys)
        var positionIndex : Int = 0
        
        for color in flowers.keys {
            if let flowersArr = flowers[color] {
                for i in 0...flowersArr.count-1 {
                    let numFlower = flowersArr[i]
                    if numFlower > 0 {
                        for _ in 1...numFlower {
                            let flower = color + "-" + mapping[i]!
                            addFlower(flower, position: validPositions[positionKeys[positionIndex]]!)
                            positionIndex += 1
                                                        
                            if positionIndex >= positionKeys.count {
                                validPositions = initializeValidPositions()
                                positionIndex = 0
                            }
                        }
                    }
                }
            }
        }
    }
    
    // For communityView
    func addFlower(_ flowerName: String, position: CGPoint){
        let node = SKSpriteNode(imageNamed: "flowers/\(flowerName)")
        node.anchorPoint = CGPoint(x: 0, y: 0)
        node.position = position
        node.colorBlendFactor = getRandomCGFloat(0, 0.2)
//        node.zPosition = 10
        node.setScale(0.1)
        
        addChild(node)
    }
    
    
}