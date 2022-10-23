//
//  Loader.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 10/21/22.
//

import SwiftUI

struct Loader: View {
    
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var gardenViewModel: GardenViewModel
    
    var body: some View {
        ZStack {
            Color.appleGreen
                .ignoresSafeArea()
            LottieView(filename: "loading-elephant")
                .frame(width: 225)
                
        }
        .onAppear {
            RemoteConfiguration.shared.fetchRemoteConfig()
            GardenViewModel.shared.addTree()
            CommunityViewModel.shared.getGoalCompletions()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                authViewModel.userOnboarded = true
            }
        }
    }
}

struct Loader_Previews: PreviewProvider {
    static var previews: some View {
        Loader()
            .environmentObject(AuthenticationViewModel())
    }
}
