//
//  Community.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 17/09/2022.
//

import SwiftUI
import SpriteKit

struct Community: View {
    
    @EnvironmentObject var communityViewModel: CommunityViewModel
    @EnvironmentObject var messagesViewModel: MessagesViewModel
    
    var weatherInfo: [String: String] = getWeatherInfo()
    @State var showMessageSheet = false
    @State var alertMessage = "Sent message ❤️⭐"
    
    var scene: SKScene {
        let scene = CommunityGardenScene()
        scene.scaleMode = .resizeFill
        return scene
    }
    
    var body: some View {
        
        ZStack(alignment: .topTrailing) {
            // Background image
            Image("community-bg")
                .resizable()
                .ignoresSafeArea(.all, edges: [.top])
                .overlay {
                    Rectangle()
                        .fill(Color(weatherInfo["color"]!))
                        .blendMode(BlendMode.overlay)
                        .ignoresSafeArea()
                }
            
            
            if communityViewModel.group != nil {
                SpriteView(scene: scene, options: [.allowsTransparency])
                    .ignoresSafeArea(.container, edges: [.top])
            }
            
            ZStack() {
                LottieView(filename: "bird")
            }
            
            VStack {
                
                ActionButton(image: "paperplane.fill", foreground: .appleGreen) {
                    showMessageSheet = true
                }
                
                Spacer()
                
                if let reactions = communityViewModel.reactions {
                    VStack(spacing: 5) {
                        
                        ActionButton(image: "heart.fill", text: String(reactions.love != nil ? reactions.love! : 0), foreground: .red) {
                            communityViewModel.sendLove()
                            let message = NotificationMessage(title: "Community Message ✉️", body: "Sent love ❤️ to members.")
                            NotificationService.shared.sendNotification(message: message, interval: 1)
                        }
                        
                        ActionButton(image: "star.fill", text: String(reactions.encouragement != nil ? reactions.encouragement! : 0), foreground: .yellow) {
                            alertMessage = "Sent encouragement ⭐ to members."
                            communityViewModel.sendEncouragement()
                            let message = NotificationMessage(title: "Community Message ✉️", body: "Sent encouragement ⭐ to members.")
                            NotificationService.shared.sendNotification(message: message, interval: 1)
                        }
                    }
                    
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 20)
        }
        .onAppear{
            communityViewModel.fetchTrees()
            communityViewModel.fetchGroup()
            SproutAnalytics.shared.viewCommunity()
        }
        .sheet(isPresented: $showMessageSheet) {
            Messages()
        }
        .sheet(isPresented: $messagesViewModel.showMessageOptionsSheet) {
            if let user = messagesViewModel.selectedUser {
                MessageOptions(user: user)
            }
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
