//
//  CommunityGardenScene.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 17/09/2022.
//

import Foundation
import SpriteKit

class CommunityGardenScene: SKScene {
    var gameTimer: Timer?
    
    override func didMove(to view: SKView) {
        
        // Background
        self.backgroundColor = .clear
        
        // Timer
        gameTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(createCloud), userInfo: nil, repeats: true)
    }
    
    
    @objc func createCloud(){
        SceneHelper.createCloud(scene: self, scale: 0.4, isCommunityView: true)
    }
}
