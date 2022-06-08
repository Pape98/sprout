//
//  LaunchView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/6/21.
//

import SwiftUI

struct LaunchView: View {
    
    @EnvironmentObject var authModel: AuthenticationViewModel
    @StateObject var userViewModel: UserViewModel = UserViewModel.shared
    @StateObject var friendsViewModel: FriendsViewModel = FriendsViewModel.shared
    @StateObject var gardenViewModel: GardenViewModel = GardenViewModel.shared
    @State var yOffset = 0
    @State var isNewUser = true
    
    var body: some View {
        
        NavigationView {
            if authModel.isLoggedIn == false {
                // Show login view
                LoginView(yOffset: $yOffset)
                
            } else {
                // Show onboarding or dashboard view
                if (isNewUser){
                    TreePicker()
                } else {
                    Dashboard()
                }
            }
        }
        .environmentObject(userViewModel)
        .environmentObject(friendsViewModel)
        .environmentObject(gardenViewModel)
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
            .environmentObject(AuthenticationViewModel())
    }
}
