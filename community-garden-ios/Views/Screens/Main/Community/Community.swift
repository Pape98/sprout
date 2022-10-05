//
//  Community.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 17/09/2022.
//

import SwiftUI
import SpriteKit
import PopupView

struct Community: View {
    
    @EnvironmentObject var communityViewModel: CommunityViewModel
    @EnvironmentObject var messagesViewModel: MessagesViewModel
    
    @State var showMessageSheet = false
    @State var showingPopup = false
    @State var popupMessage = ""
    @State var popupBackgound: Color = .red
    
    var weatherInfo: [String: String] = getWeatherInfo()
    
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
            
            // Birds
            VStack {
                LottieView(filename: "birds")
                Spacer()
                LottieView(filename: "birds")
            }
            
            if communityViewModel.group != nil {
                SpriteView(scene: scene, options: [.allowsTransparency])
                    .ignoresSafeArea(.container, edges: [.top])
            }
            
            VStack {
                
                ActionButton(image: "paperplane.fill", foreground: .appleGreen) {
                    showMessageSheet = true
                }
                
                Spacer()
                
                if let reactions = communityViewModel.reactions {
                    VStack(spacing: 5) {
                        
                        ActionButton(image: "heart.fill", text: String(reactions.love != nil ? reactions.love! : 0), foreground: .red) {
//                            communityViewModel.sendLove()
                            popupMessage = "Love sent to group"
                            popupBackgound = .red
                            showingPopup = true
                        }
                        
                        ActionButton(image: "star.fill", text: String(reactions.encouragement != nil ? reactions.encouragement! : 0), foreground: .yellow) {
//                            communityViewModel.sendEncouragement()
                            popupMessage = "Encouragment sent to group"
                            popupBackgound = .yellow
                            showingPopup = true
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
        .popup(isPresented: $showingPopup, type: Popup.PopupType.toast, position: Popup.Position.bottom, autohideIn: 2){
            
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .background(popupBackgound)
                    .opacity(0.6)
                Text(popupMessage)
            }
            .frame(width: 160, height: 40)
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
