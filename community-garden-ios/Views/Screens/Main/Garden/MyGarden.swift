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
    @EnvironmentObject var gardenViewModel: GardenViewModel
    @EnvironmentObject var appViewModel: AppViewModel
        
    let userDefaults = UserDefaultsService.shared
    
    var scene: SKScene {
        let scene = MyGardenScene()
        scene.scaleMode = .resizeFill
        return scene
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            
            // MARK: SpriteKit view
            SpriteView(scene: scene, options: [.allowsTransparency])
                .ignoresSafeArea(.container, edges:[.top])
                .weatherOverlay()
                .navigationBarTitle(userViewModel.currentUser.settings?.gardenName ?? "", displayMode: NavigationBarItem.TitleDisplayMode.inline)
                .onAppear {
                    SproutAnalytics.shared.viewOwnGarden()
                }
                .onDisappear {
                    gardenViewModel.getUserItems()
                }
            
            ZStack {
                // MARK: Mode button
                Button {
                    gardenViewModel.toggleGardenMode()
                } label: {
                    ZStack {
                        
                        Circle()
                            .fill(gardenViewModel.gardenMode == .planting ? Color.appleGreen : Color.red)
                            .opacity(0.5)
                            .frame(width:40,height:40)
                        
                        Image(systemName: gardenViewModel.gardenMode == .planting ? "lock.open.fill" : "lock.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                        
                        
                    }
                    .frame(width:40,height: 40)
                }
                .padding()
            }
            
            if gardenViewModel.gardenMode == .planting {
                HStack {
                    // Stats
                    VStack(alignment: .leading, spacing: 10) {
                        if let numDroplets = userViewModel.numDroplets {
                            Stats(image: "droplet-icon", value: Int(numDroplets.value))
                        }
                        
                        if let numSeeds = userViewModel.numSeeds {
                            Stats(image: "seed-icon", value: Int(numSeeds.value))
                        }
                    }
                    .padding()
                    
                    Spacer()
                }
                
            }
            
//            VStack {
//                Spacer()
//                LottieView(filename: "turtle_s3")
//                    .frame(height: 100)
//            }
        }
        .overlay {
            VStack {
        
                    LottieView(filename: "\(gardenViewModel.sunMoon)4")
                        .frame(width: 125, height: 125)
                        .transition(.move(edge: .trailing))
                
                Spacer()
            }
        }
        .onDisappear {
            gardenViewModel.setSunMoon()
            gardenViewModel.gardenMode = GardenViewModel.GardenMode.moving
        }
    }
}

struct Stats: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var gardenViewModel: GardenViewModel
    
    var image: String
    var value: Int
    var imageSize: CGFloat {
        40.0
    }
    
    var fontColor: Color {
        if appViewModel.backgroundColor == "night" {
            return .white
        }
        
        return .seaGreen
    }
    
    var grayscale: Double { image.contains(gardenViewModel.dropItem.rawValue) ? 0.0 : 0.9995 }
    
    var body: some View {
        HStack{
            Image(image)
                .resizable()
                .frame(maxWidth: imageSize, maxHeight: imageSize)
                .grayscale(grayscale)
            Text("\(value)")
                .font(.title2)
                .bold()
                .foregroundColor(fontColor)
        }
        .onTapGesture {
            toggleDropItem()
        }
    }
    
    func toggleDropItem(){
        gardenViewModel.dropItem = gardenViewModel.dropItem == GardenElement.droplet ?
        GardenElement.seed : GardenElement.droplet
    }
}

struct StepView_Previews: PreviewProvider {
    
    static var previews: some View {
        MyGarden()
            .background(Color.hawks)
            .environmentObject(UserViewModel())
            .environmentObject(GardenViewModel())
            .environmentObject(AppViewModel())
        
    }
}
