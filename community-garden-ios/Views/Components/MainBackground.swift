//
//  MainBackground.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 04/07/2022.
//

import SwiftUI

struct MainBackground: View {
    
    var weatherInfo: [String: String] = getWeatherInfo()
    @State var appViewModel : AppViewModel = AppViewModel.shared
    
    var image: String = "intro-bg"
    var edges: Edge.Set = [.top]
    
    var body: some View {
        Image(appViewModel.backgroundImage)
            .resizable()
            .ignoresSafeArea(.all, edges: edges)
            .overlay {
                Rectangle()
                    .fill(Color(appViewModel.backgroundColor))
                    .blendMode(BlendMode.overlay)
                    .ignoresSafeArea()
            }
    }
}

struct MainBackground_Previews: PreviewProvider {
    @State static var appViewModel: AppViewModel = AppViewModel()
    static var previews: some View {
        MainBackground()
    }
}
