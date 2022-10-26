//
//  MainBackground.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 04/07/2022.
//

import SwiftUI

struct MainBackground: View {
    
    @State var appViewModel : AppViewModel = AppViewModel.shared
    
    var image: String? = nil
    var edges: Edge.Set = [.top]
    
    var body: some View {
        if let image = image {
            Image(image)
                .resizable()
                .ignoresSafeArea(.all, edges: edges)
                .scaledToFill()
        } else {
            Image(appViewModel.introBackground)
                .resizable()
                .ignoresSafeArea(.all, edges: edges)
                .onAppear {
                    appViewModel.setIntroBackground()
                }
        }
    }
}

struct MainBackground_Previews: PreviewProvider {
    @State static var appViewModel: AppViewModel = AppViewModel()
    static var previews: some View {
        MainBackground()
    }
}
