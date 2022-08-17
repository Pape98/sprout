//
//  MainView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 28/06/2022.
//

import SwiftUI
import AVFoundation

struct MainView: View {
    
    // MARK: View Models
    @StateObject var healthStoreViewModel: HealthStoreViewModel = HealthStoreViewModel.shared
    @StateObject var userViewModel: UserViewModel = UserViewModel.shared
    @StateObject var friendsViewModel: FriendsViewModel = FriendsViewModel.shared
    @StateObject var gardenViewModel: GardenViewModel = GardenViewModel.shared
    @StateObject var messagesViewModel: MessagesViewModel = MessagesViewModel.shared
    
    let userDefaults = UserDefaultsService.shared
    
    var body: some View {
        
        TabView {
            
            Dashboard()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
            
            Messages()
                .badge(2)
                .tabItem {
                    Label("Messages", systemImage: "message")
                }
            
            FriendsList()
                .tabItem {
                    Label("Friends", systemImage: "person.3")
                        .onTapGesture {
                            AudioPlayer.playSystemSound(soundID: 1057)
                            print("tap")
                        }
                }
            
            Settings()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .accentColor(.appleGreen)
        .environmentObject(userViewModel)
        .environmentObject(friendsViewModel)
        .environmentObject(healthStoreViewModel)
        .environmentObject(gardenViewModel)
        .environmentObject(messagesViewModel)
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
