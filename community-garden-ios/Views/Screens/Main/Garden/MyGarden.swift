//
//  StepView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/19/21.
//

import SwiftUI
import SpriteKit
import AlertToast

struct MyGarden: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var gardenViewModel: GardenViewModel
    @EnvironmentObject var communityViewModel: CommunityViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    
    var scene: SKScene {
        let scene = MyGardenScene()
        scene.scaleMode = .resizeFill
        return scene
    }
    var sunMoonLevel: Int {
        let numTargetGoals = (communityViewModel.members.count + 1) * 2
        guard let goalStat = communityViewModel.goalsStat else { return 0 }
        return Int(goalStat.numberOfGoalsAchieved / numTargetGoals)
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
            
            
        }
        .toast(isPresenting: $gardenViewModel.showToast, duration: 5, tapToDismiss: true) {
            AlertToast(displayMode: .banner(.slide),
                       type: .systemImage(gardenViewModel.toastMessage.image, gardenViewModel.toastMessage.color),
                       title: gardenViewModel.toastMessage.title, subTitle: gardenViewModel.toastMessage.subtitle)
        }
        .overlay {
            VStack {
                
                LottieView(filename: "\(gardenViewModel.sunMoon)\(getSunMoonLevel())")
                    .frame(width: 125, height: 125)
                    .transition(.move(edge: .trailing))
                Spacer()
            }
        }
        .onDisappear {
            gardenViewModel.setSunMoon()
            gardenViewModel.gardenMode = GardenViewModel.GardenMode.moving
            communityViewModel.getGoalCompletions()
        }
    }
    
    func getSunMoonLevel() -> Int {
        let numTargetGoals = (communityViewModel.members.count + 1) * 2
        guard let goalStat = communityViewModel.goalsStat else { return 1 }
        let percentCompletion = Double(goalStat.numberOfGoalsAchieved) / Double(numTargetGoals)
                
        if percentCompletion >= 0.75 { return 4 }
        else if percentCompletion >= 0.5 { return 3 }
        else if percentCompletion >= 0.25 { return 2 }
        else { return 1 }
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
