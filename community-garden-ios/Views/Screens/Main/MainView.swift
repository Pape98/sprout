//
//  MainView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 28/06/2022.
//

import SwiftUI

struct MainView: View {
    
    // MARK: View Models
    @StateObject var healthStoreViewModel: HealthStoreViewModel = HealthStoreViewModel.shared
    @StateObject var userViewModel: UserViewModel = UserViewModel.shared
    @StateObject var friendsViewModel: FriendsViewModel = FriendsViewModel.shared
    @StateObject var gardenViewModel: GardenViewModel = GardenViewModel.shared    
    
    var body: some View {
        
        TabView {
            
//            Settings()
//                .tabItem {
//                    Label("Settings", systemImage: "gearshape")
//                }
//
            Dashboard()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
            
            FriendsList()
                .tabItem {
                    Label("My Friends", systemImage: "person.3")
                }
            
            Settings()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .environmentObject(userViewModel)
        .environmentObject(friendsViewModel)
        .environmentObject(healthStoreViewModel)
        .environmentObject(gardenViewModel)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(UserViewModel())
            .environmentObject(HealthStoreViewModel())
            .environmentObject(FriendsViewModel())
    }
}
