//
//  StepView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/19/21.
//

import SwiftUI
import SpriteKit

struct MyGarden: View {
    
    @State private var dropElement = GardenElement.droplet
    @State private var showPickDropElementAlert = false
    
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var gardenViewModel: GardenViewModel

    let userDefaults = UserDefaultsService.shared
    
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
            .ignoresSafeArea(.container, edges:[.top])
            .weatherOverlay()
            .navigationBarTitle(gardenName, displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button("Pick"){
                            showPickDropElementAlert = true
                        }
                        
                        Image(dropElement.rawValue)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        
                    }
                }
            }
            .alert("I want to drop a ...", isPresented: $showPickDropElementAlert) {
                Button("\(GardenElement.droplet.rawValue)💧"){
                    dropElement = GardenElement.droplet
                }
                Button("\(GardenElement.seed.rawValue)🌱"){
                    dropElement = GardenElement.seed
                }
            }
        
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
            .environmentObject(UserViewModel())
            .environmentObject(GardenViewModel())
        
    }
}
