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
        let scene = MyGardenScene()
        scene.scaleMode = .resizeFill
        return scene
    }
    
    var body: some View {
        // Scene View
        SpriteView(scene: scene, options: [.allowsTransparency])
            .weatherOverlay()
    }
}
    
    struct Stats: View {
        
        var image: String
        var value: Int
        var imageSize: CGFloat {
            40.0
        }
        
        var body: some View {
            HStack{
                Image(image)
                    .resizable()
                    .frame(maxWidth: imageSize, maxHeight: imageSize)
                Text("\(value)")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.seaGreen)
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
