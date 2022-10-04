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
    
    @State var showSunMoon = false
    
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
                    
                        showSunMoon = true
                    
                }
                .onDisappear {
                    gardenViewModel.getUserItems()
                }
            
            ZStack {
                VStack(spacing: 10) {
                    
                    // MARK: Mode button
                    Button {
                        gardenViewModel.toggleGardenMode()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(gardenViewModel.gardenMode == .planting ? Color.appleGreen : Color.red)
                                .opacity(0.5)
                                .frame(width:45,height:45)
                            
                            Image("gardening")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                            
                            
                        }
                        .frame(width:45,height: 45)
                    }
                    
                    // MARK: Drop Item toggle
                    Button {
                        toggleDropItem()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(.white)
                                .opacity(0.5)
                                .frame(width:45,height: 45)
                            
                            Image(gardenViewModel.dropItem.rawValue)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                            
                            
                        }
                        .frame(width:45,height: 45)
                    }
                    
                }
                .padding()
            }
            
        }
        .overlay {
            VStack {
                if showSunMoon {
                    LottieView(filename: "moon-jubilant")
                        .frame(width: 150, height: 200)
                        .transition(.move(edge: .trailing))
                        .offset(y: -25)
                }
                Spacer()
            }
        }
        .onDisappear {
            gardenViewModel.gardenMode = GardenViewModel.GardenMode.moving
        }
    }
    
    func toggleDropItem(){
        gardenViewModel.dropItem = gardenViewModel.dropItem == GardenElement.droplet ?
        GardenElement.seed : GardenElement.droplet
    }
}

struct Stats: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    
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
    
    var body: some View {
        HStack{
            Image(image)
                .resizable()
                .frame(maxWidth: imageSize, maxHeight: imageSize)
            Text("\(value)")
                .font(.title2)
                .bold()
                .foregroundColor(fontColor)
        }
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
