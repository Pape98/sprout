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
    
    let userDefaults = UserDefaultsService.shared
    
    var scene: SKScene {
        let scene = MyGardenScene()
        scene.scaleMode = .resizeFill
        return scene
    }
    
    var body: some View {
        ZStack() {
            
            // MARK: SpriteKit view
            
            SpriteView(scene: scene, options: [.allowsTransparency])
                .ignoresSafeArea(.container, edges:[.top])
                .weatherOverlay()
                .navigationBarTitle(userViewModel.currentUser.settings?.gardenName ?? "", displayMode: NavigationBarItem.TitleDisplayMode.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            Button("Switch"){
                                toggleDropItem()
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
                    SproutAnalytics.shared.viewOwnGarden()
                }
                .onDisappear {
                    gardenViewModel.getUserItems()
                }
            
            // MARK: Lottie View
            
            VStack {
                //
                //                LottieView(filename: "bird")
                //                    .offset(y: 30)
                
                Spacer()
//                LottieView(filename: "bird")
//                    .frame(height: 150)
            }
            
        }
        
    }
    
    func toggleDropItem(){
        gardenViewModel.dropItem = gardenViewModel.dropItem == GardenElement.droplet ?
        GardenElement.seed : GardenElement.droplet
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
