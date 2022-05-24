//
//  StepView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/19/21.
//

import SwiftUI
import SpriteKit

struct MyGarden: View {
    
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    var scene: SKScene {
        let scene = GameScene()
        scene.scaleMode = .resizeFill
        return scene
    }
    
    var body: some View {
        
        ZStack{
            SpriteView(scene: scene)
                .edgesIgnoringSafeArea(.top)
            VStack {
                HStack {
                    if let stepCount = userViewModel.currentUser.stepCount {
                        Text("Steps: \(stepCount.count)")
                    }
                    Spacer()
                    
                    if let user = userViewModel.currentUser {
                        Text("Droplets: \(user.numDroplets)")
                    }
                }
                .padding(20)
                Spacer()
            }
            
            
        }
        
        
        
    }
}

struct StepView_Previews: PreviewProvider {
    
    @State static var steps: [Step] = [Step(date: Date.now, count: 894),
                                       Step(date: Date.now, count: 1500),
                                       Step(date: Date.now, count: 2060),
                                       Step(date: Date.now, count: 100)]
    
    static var previews: some View {
        MyGarden()
        
    }
}
