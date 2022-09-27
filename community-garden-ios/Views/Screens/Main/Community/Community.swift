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
                .ignoresSafeArea(.container, edges: [.top])
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
            
            HStack() {
                
                ActionButton(image: "paperplane.fill", foreground: .appleGreen) {
                    showMessageSheet = true
                }
                
                Spacer()
                
                if let reactions = communityViewModel.reactions {
                    ActionButton(image: "heart.fill", text: String(reactions.love), foreground: .red) {
                        communityViewModel.sendLove()
                    }
                }
            }
            .padding(.horizontal)
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
            ZStack {
                Circle()
                    .fill(.white)
                    .opacity(0.5)
                Image(systemName: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(foreground)
                    .frame(width: 25, height: 25)
                
                if text != "" {
                    Text(text)
                        .foregroundColor(.white)
                        .font(.system(size: 11))
                        .bold()
                }
                
            }
            .frame(width: 45, height: 45,alignment: .center)
        }
    }
    
}

struct Community_Previews: PreviewProvider {
    static var previews: some View {
        Community()
    }
}
