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
    @State var showPickMessageTypeAlert = false
    
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
            
            Color.yellowGreen
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
                        Image("community-bg-2")
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
                        
                        ActionButton(image: "globe", foreground: .grenadier) {
                            messagesViewModel.showCommunityFeedSheet = true
                        }
                        
                        ActionButton(image: "paperplane.fill", foreground: .tangerine) {
                            showPickMessageTypeAlert = true
                        }
                        
                        Spacer()
                        
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 20)
                }
            }
        }
        .onAppear{
            communityViewModel.fetchTrees()
            communityViewModel.fetchGroup()
        }
        .sheet(isPresented: $messagesViewModel.showUserMessageSheet) {
            UserMessages()
        }
        .sheet(isPresented: $messagesViewModel.showSendSingleUserMessageSheet) {
            SendSingleUserMessage()
        }
        .sheet(isPresented: $messagesViewModel.showSendCommunityMessageSheet) {
            SendCommunityMessage()
        }
        .sheet(isPresented: $messagesViewModel.showCommunityFeedSheet) {
            CommunityFeed()
        }
        
        .toast(isPresenting: $communityViewModel.showToast) {
            AlertToast(displayMode: .hud,
                       type: AlertToast.AlertType.systemImage(communityViewModel.toastImage, communityViewModel.toastColor),
                       title: communityViewModel.toastTitle)
        }
        .alert("Send to message to...", isPresented: $showPickMessageTypeAlert) {
            Button("Single User 👤", role: .none) { messagesViewModel.showSendSingleUserMessageSheet = true}
            Button("Community 👥", role: .none) { messagesViewModel.showSendCommunityMessageSheet = true }
            Button("Cancel", role : .cancel) { showPickMessageTypeAlert = false }
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
