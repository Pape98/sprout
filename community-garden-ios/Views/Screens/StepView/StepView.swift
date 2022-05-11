//
//  StepView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/19/21.
//

import SwiftUI
import SpriteKit

struct StepView: View {
    
    
    @EnvironmentObject var healthStoreViewModel: HealthStoreViewModel
    
    var scene: SKScene {
        let scene = GameScene()
        scene.scaleMode = .resizeFill
        return scene
    }
    
    
    
    var body: some View {
        ZStack{
            SpriteView(scene: scene)
                .edgesIgnoringSafeArea(.top)
            
            if let step = healthStoreViewModel.steps.first {
                VStack {
                    HStack {
                        Text("Steps: \(step.count)" )
                        Spacer()
                    }
                    Spacer()
                }
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
        //        StepView(steps: steps)
        //            .environmentObject(HealthStoreViewModel())
        StepView()
        
    }
}
