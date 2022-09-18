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
    var havePlacedTrees = false
    var validPositions: [String: CGPoint] = [:]
    
    // Nodes
    var river : SKSpriteNode?
    var fence: SKSpriteNode?
    
    // ViewModels
    @ObservedObject var communityViewModel = CommunityViewModel.shared
    
    override func didMove(to view: SKView) {
        
        // Background
        self.backgroundColor = .clear
        
        // Timer
        gameTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(createCloud), userInfo: nil, repeats: true)
        
        
        
        // Setting up scene elements
        river = setupRiver()
        fence = setupFence(location: CGPoint(x: 0, y: river!.position.y - 100), anchor: CGPoint(x: 0, y: 0))
        validPositions = initializeValidPositions()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(!communityViewModel.trees.isEmpty && !havePlacedTrees){
            setupTrees()
            havePlacedTrees = true
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
        
        let topLeft = CGPoint(x: getRandomCGFloat(10, frame.midX-50), y: getRandomCGFloat(riverTop, riverTop + 50))
        let topRight = CGPoint(x: getRandomCGFloat(frame.midX + 10, frame.maxX-50), y: getRandomCGFloat(riverTop, riverTop + 50))

        let bottomLeft = CGPoint(x: getRandomCGFloat(10, frame.midX-50), y: getRandomCGFloat(0, fenceBottom - 100))
        let bottomRight = CGPoint(x: getRandomCGFloat(frame.midX + 10, frame.maxX-50), y: getRandomCGFloat(0,fenceBottom - 100))
        
        return ["topLeft": topLeft,"topRight": topRight,"bottomLeft" : bottomLeft ,"bottomRight":bottomRight]
    }
}
