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
    @StateObject var healthStoreViewModel: HealthStoreViewModel = HealthStoreViewModel.shared
    @StateObject var userViewModel: UserViewModel = UserViewModel.shared
    @StateObject var friendsViewModel: FriendsViewModel = FriendsViewModel.shared
    @StateObject var gardenViewModel: GardenViewModel = GardenViewModel.shared
    @StateObject var onboardingViewModel: OnboardingViewModel = OnboardingViewModel.shared
    // Routers
    @StateObject var onboardingRouter: OnboardingRouter = OnboardingRouter.shared
    
    // States
    @State var yOffset = 0
    
    var body: some View {
        
        Group {
            if authModel.isLoggedIn == false {
                // Show login view
                LoginView(yOffset: $yOffset)
                
            } else {
                // Show onboarding or dashboard view
                if (onboardingViewModel.isNewUser == OnboardingStatus.NEW_USER){
                    Onboarding()
                } else {
                    MainView()
                }
            }
        }
        .foregroundColor(.seaGreen)
        .environmentObject(userViewModel)
        .environmentObject(friendsViewModel)
        .environmentObject(gardenViewModel)
        .environmentObject(onboardingViewModel)
        .environmentObject(onboardingRouter)
        .environmentObject(healthStoreViewModel)
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
            .environmentObject(AuthenticationViewModel())
    }
}
