//
//  LaunchScreen.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 22/07/2022.
//

import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        ZStack {
            Color("launchScreenBackground")
            Image("launchScreenLogo")
                .resizable()
                .scaledToFit()
                .frame(width:150, height: 150)
            

        }
        .ignoresSafeArea()

    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
