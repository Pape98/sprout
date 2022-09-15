//
//  MainBackground.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 04/07/2022.
//

import SwiftUI

struct MainBackground: View {
    
    var weatherInfo = getWeatherInfo()
    var image: String = "intro-bg"
    var edges: Edge.Set = [.top]
    
    var body: some View {
        Image(image)
            .resizable()
            .ignoresSafeArea(.container, edges: edges)
            .overlay {
                Rectangle()
                    .fill(Color.day)
                    .blendMode(BlendMode.overlay)
                    .ignoresSafeArea()
            }
    }
}

struct MainBackground_Previews: PreviewProvider {
    static var previews: some View {
        MainBackground()
    }
}
