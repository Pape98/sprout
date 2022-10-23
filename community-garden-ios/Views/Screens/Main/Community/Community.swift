//
//  Community.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 17/09/2022.
//

import SwiftUI
import SpriteKit
import AlertToast
import Foundation

struct Community: View {
    
    @EnvironmentObject var communityViewModel: CommunityViewModel
    @EnvironmentObject var messagesViewModel: MessagesViewModel
    @EnvironmentObject var appViewModel: AppViewModel
        
    let userDefaults = UserDefaultsService.shared
    var weatherInfo: [String: String] = getWeatherInfo()
    
    var scene: SKScene {
        let scene = CommunityGardenScene()
        scene.scaleMode = .resizeFill
        return scene
    }
    
    var animals: [String: Any] = [
        "dog": 130,
        "deer": 110,
    ]
    
    var viewSize: CGFloat {
        let communityViewParams = RemoteConfiguration.shared.getConfigs(key: "communityViewParams")
        guard let communityViewParams = communityViewParams else { return 1 }
        return communityViewParams["communityViewHeight"] as! CGFloat
    }
    
    var body: some View {
        
        GeometryReader { geo in
            
            Color.greenishBlue
                .edgesIgnoringSafeArea(.top)
                .overlay {
                    Rectangle()
                        .fill(Color(appViewModel.backgroundColor))
                        .blendMode(BlendMode.overlay)
                        .ignoresSafeArea()
                }
            
            ZStack(alignment: .topTrailing) {
                
                ScrollView {
                    ZStack {
                        // Background image
                        Image("community-bg")
                            .resizable()
                            .ignoresSafeArea(.all, edges: [.all])
                            .frame(height: geo.size.height * 1.5)
                        
                        
                        // Sprites
                        if communityViewModel.group != nil {
                            SpriteView(scene: scene, options: [.allowsTransparency])
                                .ignoresSafeArea(.container, edges: [.top])
                            
                        }
                        
                        VStack {
                            Spacer()
                            if appViewModel.isBadgeUnlocked(UnlockableBadge.dog){
                                LottieView(filename: "dog_d2")
                                    .frame(height: geo.size.height * 0.11)
                                    .offset(y: -geo.size.height * 0.04)
                            }

                            Spacer(minLength: 10)

                            if appViewModel.isBadgeUnlocked(UnlockableBadge.turtle){
                                LottieView(filename: "turtle_s3")
                                    .frame(height: geo.size.height * 0.13)
                                    .offset(x: 0, y: geo.size.height * -0.05)
                            }


                            Spacer()

                            if appViewModel.isBadgeUnlocked(UnlockableBadge.deer){
                                LottieView(filename: "deer_a5")
                                    .frame(height: geo.size.height * 0.155)
                            }

                            Spacer()
                            
                            if appViewModel.isBadgeUnlocked(UnlockableBadge.dog){
                                LottieView(filename: "dog_s3")
                                    .frame(height: geo.size.height * 0.23)
                                    .offset(x: geo.size.width * 0.25, y: -geo.size.width * 0.1)
                            }
                        }
                        
                        
                        
                        if appViewModel.isBadgeUnlocked(UnlockableBadge.birds){
                            VStack {
                                LottieView(filename: "birds")
                                LottieView(filename: "birds")
                                LottieView(filename: "birds")
                                LottieView(filename: "birds")
                            }
                        }
                        
                        
                    }
                    .overlay {
                        
                        ZStack {
                            Rectangle()
                                .fill(Color(appViewModel.backgroundColor))
                                .blendMode(BlendMode.overlay)
                                .ignoresSafeArea()
                        }
                    }
                }
                
                ZStack {
                    VStack {
                        
                        ActionButton(image: "envelope.fill", foreground: .everglade) {
                            messagesViewModel.showUserMessageSheet = true
                        }
                        
                        ActionButton(image: "paperplane.fill", foreground: .tangerine) {
                            messagesViewModel.showSendMessageSheet = true
                        }
                        
                        Spacer()
                        
                        if let reactions = communityViewModel.reactions {
                            VStack(spacing: 5) {
                                
                                ActionButton(image: "heart.fill", text: String(reactions.love != nil ? reactions.love! : 0), foreground: .red) {
                                    communityViewModel.sendLove()
                                }
                                
                                ActionButton(image: "star.fill", text: String(reactions.encouragement != nil ? reactions.encouragement! : 0), foreground: .yellow) {
                                    communityViewModel.sendEncouragement()
                                }
                            }
                            
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 20)
                }
            }
        }
        .onAppear{
            communityViewModel.fetchTrees()
            communityViewModel.fetchGroup()
            appViewModel.setBackground()
        }
        .sheet(isPresented: $messagesViewModel.showUserMessageSheet) {
            UserMessages()
        }
        .sheet(isPresented: $messagesViewModel.showSendMessageSheet) {
            SendMessage()
        }
        
        .toast(isPresenting: $communityViewModel.showToast) {
            AlertToast(displayMode: .hud,
                       type: AlertToast.AlertType.systemImage(communityViewModel.toastImage, communityViewModel.toastColor),
                       title: communityViewModel.toastTitle)
        }
    }
    
    @ViewBuilder
    func ActionButton(image: String, text: String = "", foreground: Color, _ callback: @escaping () -> Void) -> some View {
        Button {
            callback()
        } label: {
            ZStack(alignment: .center) {
                Circle()
                    .fill(.white)
                    .opacity(0.5)
                Image(systemName: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(foreground)
                    .frame(width: 30, height: 30)
                
                if text != "" {
                    Text(text)
                        .foregroundColor(.white)
                        .font(.system(size: 11))
                        .bold()
                }
                
            }
            .frame(width: 45, height: 45,alignment: .center)
        }
        .padding(.bottom, 10)
    }
    
}

struct Community_Previews: PreviewProvider {
    static var previews: some View {
        Community()
            .environmentObject(AppViewModel())
            .environmentObject(CommunityViewModel())
            .environmentObject(MessagesViewModel())
    }
}
