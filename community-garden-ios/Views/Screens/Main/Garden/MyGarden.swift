//
//  StepView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/19/21.
//

import SwiftUI
import SpriteKit

struct MyGarden: View {
    
    @State private var showPickDropElementAlert = false
    
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var gardenViewModel: GardenViewModel

    let userDefaults = UserDefaultsService.shared

    
    var scene: SKScene {
        let scene = MyGardenScene()
        scene.scaleMode = .resizeFill
        return scene
    }
    
    var body: some View {
        ZStack {
            
            // MARK: SpriteKit view
            
            SpriteView(scene: scene, options: [.allowsTransparency])
                .ignoresSafeArea(.container, edges:[.top])
                .weatherOverlay()
                .navigationBarTitle(userViewModel.currentUser.settings?.gardenName ?? "", displayMode: NavigationBarItem.TitleDisplayMode.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            Button("Pick"){
                                showPickDropElementAlert = true
                                gardenViewModel.saveItems()
                            }
                            .foregroundColor(.black)
                            
                            Image(gardenViewModel.dropItem.rawValue)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                            
                        }
                    }
                }
                .onAppear {
                    gardenViewModel.getUserItems()
                }
                .onDisappear {
                    gardenViewModel.saveItems()
                }
                .alert("I want to drop a ...", isPresented: $showPickDropElementAlert) {
                    Button("\(GardenElement.droplet.rawValue)💧"){
                        gardenViewModel.dropItem = GardenElement.droplet
                    }
                    Button("\(GardenElement.seed.rawValue)🌱"){
                        gardenViewModel.dropItem = GardenElement.seed
                    }
            }
            
            // MARK: Lottie View
            
//            LottieView(filename: "lego")
//                .frame(width: 200, height: 200)
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
