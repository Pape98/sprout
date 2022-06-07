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
    
    var body: some View {
        
        Group {
            if authModel.isLoggedIn == false {
                // Show login view
                LoginView(yOffset: $yOffset)
                
            } else {
                // Show dashboard or onboarding view
                
//                LoginView(yOffset: $yOffset).onAppear {
//                    yOffset = 1000
//                }
                TreePicker()
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
