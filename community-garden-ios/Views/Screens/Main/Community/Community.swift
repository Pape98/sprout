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
    
    @State var showMessageSheet = false
    @State var showToast = false
    
    @State var toastTitle = ""
    @State var toastImage = ""
    @State var toastColor: Color = .red
    
    var weatherInfo: [String: String] = getWeatherInfo()
    var animalSize: CGFloat {
        75
    }
    
    var scene: SKScene {
        let scene = CommunityGardenScene()
        scene.scaleMode = .resizeFill
        return scene
    }
    
    //    var backgroundHeight: CGFloat {
    //        let height = ceil(CGFloat(communityViewModel.trees.count) / 4)
    //        print(height)
    //        return 2
    //    }
    
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
                            .frame(height: geo.size.height * 2)
                        
                        // Birds
                        
                        // Sprites
                        if communityViewModel.group != nil {
                            SpriteView(scene: scene, options: [.allowsTransparency])
                                .ignoresSafeArea(.container, edges: [.top])
                            
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
                        
                        ActionButton(image: "paperplane.fill", foreground: .appleGreen) {
                            showMessageSheet = true
                        }
                        
                        if let reactions = communityViewModel.reactions {
                            VStack(spacing: 5) {
                                
                                ActionButton(image: "heart.fill", text: String(reactions.love != nil ? reactions.love! : 0), foreground: .red) {
                                    communityViewModel.sendLove()
                                    toastTitle = "Sent love to 🧑‍🤝‍🧑"
                                    toastImage = "heart.fill"
                                    toastColor = .red
                                    showToast = true
                                }
                                
                                ActionButton(image: "star.fill", text: String(reactions.encouragement != nil ? reactions.encouragement! : 0), foreground: .yellow) {
                                    communityViewModel.sendEncouragement()
                                    toastTitle = "Sent cheers to 🧑‍🤝‍🧑"
                                    toastImage = "star.fill"
                                    toastColor = .yellow
                                    showToast = true
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
            SproutAnalytics.shared.viewCommunity()
            appViewModel.setBackground()
        }
        .sheet(isPresented: $showMessageSheet) {
            Messages()
        }
        .sheet(isPresented: $messagesViewModel.showMessageOptionsSheet) {
            if let user = messagesViewModel.selectedUser {
                MessageOptions(user: user)
            }
        }
        .toast(isPresenting: $showToast) {
            AlertToast(displayMode: .hud,
                       type: AlertToast.AlertType.systemImage(toastImage, toastColor),
                       title: toastTitle)
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
