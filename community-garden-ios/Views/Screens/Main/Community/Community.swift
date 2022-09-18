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
            Image("community-grass-bg")
                .resizable()
                .ignoresSafeArea(.container, edges: [.top])
                .overlay {
                    Rectangle()
                        .fill(Color(weatherInfo["color"]!))
                        .blendMode(BlendMode.overlay)
                        .ignoresSafeArea()
                }
            
            SpriteView(scene: scene, options: [.allowsTransparency])
                .ignoresSafeArea(.container, edges: [.top])
            
            VStack(spacing: 15) {
                Button(image: "paperplane"){
                    showMessageSheet = true
                }
                Button(image: "clock.arrow.circlepath"){
                    communityViewModel.fetchTrees()
                }
            }
            .padding()
            
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
    func Button(image: String,_ callback: @escaping () -> Void) -> some View {
        VStack {
            ZStack{
                Circle()
                    .fill(Color.white)
                    .opacity(0.7)
                
                Image(systemName: image)
                    .foregroundColor(.white)
            }
            .frame(width: 40, height: 40)
        }
        
        .onTapGesture {
            callback()
        }
    }
}

struct Community_Previews: PreviewProvider {
    static var previews: some View {
        Community()
    }
}
