//
//  Modifiers.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 20/06/2022.
//

import Foundation
import SwiftUI

struct WeatherOverlay: ViewModifier {
    func body(content: Content) -> some View {
        
        ZStack(alignment: .topLeading) {
            // Background Image
            Image("day-bg")
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
                .fill(Color.day)
                .blendMode(BlendMode.overlay)
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
        .opacity(0.85)
    }
}

struct Droppable: ViewModifier {
    let condition: Bool
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if condition {
            content
        } else {
            content
        }
    }
}
