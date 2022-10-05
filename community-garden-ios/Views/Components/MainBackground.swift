//
//  MainBackground.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 04/07/2022.
//

import SwiftUI

struct MainBackground: View {
    
    @State var appViewModel : AppViewModel = AppViewModel.shared
    
    var image: String = "intro-bg"
    var edges: Edge.Set = [.top]
    
    var body: some View {
        Image(getIntroBackground())
            .resizable()
            .ignoresSafeArea(.all, edges: edges)
    }
}

struct MainBackground_Previews: PreviewProvider {
    @State static var appViewModel: AppViewModel = AppViewModel()
    static var previews: some View {
        MainBackground()
    }
}
