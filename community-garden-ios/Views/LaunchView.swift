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
    @StateObject var userViewModel: UserViewModel = UserViewModel.shared
    @StateObject var friendsViewModel: FriendsViewModel = FriendsViewModel.shared
    @StateObject var gardenViewModel: GardenViewModel = GardenViewModel.shared
    
    // Routers
    @StateObject var onboardingRouter: OnboardingRouter = OnboardingRouter.shared
    
    // Others
    @State var yOffset = 0
    @State var isNewUser = true
    
    var body: some View {
        
        Group {
            if authModel.isLoggedIn == false {
                // Show login view
                LoginView(yOffset: $yOffset)
                
            } else {
                // Show onboarding or dashboard view
                if (isNewUser){
                    Onboarding()
                } else {
                    Dashboard()
                }
            }
        }
        .foregroundColor(.seaGreen)
        .environmentObject(userViewModel)
        .environmentObject(friendsViewModel)
        .environmentObject(gardenViewModel)
        .environmentObject(onboardingRouter)
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
            .environmentObject(AuthenticationViewModel())
    }
}
