//
//  StepView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/19/21.
//

import SwiftUI
import SpriteKit

struct MyGarden: View {
    
    let userDefaults = UserDefaultsService.shared
    @EnvironmentObject var userViewModel: UserViewModel
    
    var gardenName: String {
        userDefaults.get(key: UserDefaultsKey.GARDEN_NAME) ?? "Your Garden"
    }
    
    var scene: SKScene {
        let scene = MyGardenScene()
        scene.scaleMode = .resizeFill
        return scene
    }
    
    var body: some View {
        // Scene View
        SpriteView(scene: scene, options: [.allowsTransparency])
            .weatherOverlay()
            .navigationBarTitle(gardenName, displayMode: .inline)

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
        
        static var previews: some View {
            MyGarden()
                .background(Color.hawks)
            
        }
    }
