//
//  LaunchView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/6/21.
//

import SwiftUI

struct LaunchView: View {
    
    // View Models
    @EnvironmentObject var authModel: AuthenticationViewModel
    @StateObject var onboardingViewModel: OnboardingViewModel = OnboardingViewModel.shared
    @StateObject var userViewModel: UserViewModel = UserViewModel.shared

    // Routers
    @StateObject var onboardingRouter: OnboardingRouter = OnboardingRouter.shared
    
    // States
    @State private var yOffset = 0
    
    var userDefaults = UserDefaultsService.shared
    
    var body: some View {
        
        ZStack {
            if authModel.isLoggedIn == false {
                // Show login view
                LoginView(yOffset: $yOffset)
                
            } else {
                // Show onboarding or dashboard view
                if let userOnboarded = authModel.userOnboarded {
                    if userOnboarded {
                        MainView()
                    } else {
                        Onboarding()
                    }
                } else {
                    LaunchScreen()
                }
            }
        }
        .onAppear {
            authModel.checkLogin()
        }
        .environmentObject(onboardingViewModel)
        .environmentObject(onboardingRouter)
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
            .environmentObject(AuthenticationViewModel())
    }
}
