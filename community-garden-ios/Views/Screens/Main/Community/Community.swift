//
//  Community.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 17/09/2022.
//

import SwiftUI
import SpriteKit

struct Community: View {
    
    var weatherInfo: [String: String] = getWeatherInfo()
    
    var scene: SKScene {
        let scene = CommunityGardenScene()
        scene.scaleMode = .resizeFill
        return scene
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
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
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    
    @ViewBuilder
    func RefreshButton() -> some View {
        ZStack{
            Circle()
                .fill(Color.seaGreen)
                .opacity(0.5)
                .shadow(color: .black, radius: 1, x: 0, y: 4)

            Text("Refresh")
                .foregroundColor(.white)
        }
        .frame(width:80, height: 80)
    }
}

struct Community_Previews: PreviewProvider {
    static var previews: some View {
        Community()
    }
}
