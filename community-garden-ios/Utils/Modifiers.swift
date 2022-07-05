//
//  Modifiers.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 20/06/2022.
//

import Foundation
import SwiftUI

struct WeatherOverlay: ViewModifier {
    
    var weatherInfo = getWeatherInfo()
    
    func body(content: Content) -> some View {
        
        ZStack(alignment: .topLeading) {
            // Background Image
            Image(weatherInfo["image"]!)
                .resizable()
                .ignoresSafeArea()
            // Scene View
            content
            
            // Stats
            VStack(alignment: .leading) {
                Stats(image: "droplet-icon", value:5)
                Stats(image: "step-icon", value: 1247)
                Spacer()
            }
            .padding()
        }
        
        .overlay {
            Rectangle()
                .fill(Color(weatherInfo["color"]!))
                .blendMode(BlendMode.overlay)
                .edgesIgnoringSafeArea([.top])
        }
    }
}

struct Segment: ViewModifier {
    func body(content: Content) -> some View {
        VStack {
            content
        }
        .padding()
        .background(.white)
        .border(Color.ceramic, width: 3)
        .cornerRadius(10)
        .opacity(0.80)
    }
}

struct Droppable: ViewModifier {
    var condition: Bool
    var action: ([NSItemProvider]) -> Void
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if condition {
            content.onDrop(of: [.url], isTargeted: .constant(false)) { providers in
                action(providers)
                return false
            }
        } else {
            content
        }
    }
}

