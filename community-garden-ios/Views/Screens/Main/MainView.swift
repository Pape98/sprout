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
    @StateObject var historyViewModel: HistoryViewModel = HistoryViewModel.shared
    
    let userDefaults = UserDefaultsService.shared
    let soundID:UInt32 = 1306
    
    var body: some View {
        
        TabView {
            
            Dashboard()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
                .onAppear {
                    playSound()
                }
            
            Messages()
                .badge(2)
                .tabItem {
                    Label("Messages", systemImage: "message")
                }
                .onAppear {
                    playSound()
                }
            
            FriendsList()
                .tabItem {
                    Label("Friends", systemImage: "person.3")
                }
                .onAppear {
                    playSound()
                }
            
//            History()
//                .tabItem {
//                    Label("History", systemImage: "target")
//                }
//                .onAppear {
//                    playSound()
//                }
            
            Settings()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .onAppear {
                    playSound()
                }
        }
        .accentColor(.appleGreen)
        .environmentObject(userViewModel)
        .environmentObject(friendsViewModel)
        .environmentObject(healthStoreViewModel)
        .environmentObject(gardenViewModel)
        .environmentObject(messagesViewModel)
        .environmentObject(historyViewModel)
    }
    func playSound(){
        AudioPlayer.playCustomSound(filename: "click2.mp3")
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(UserViewModel())
            .environmentObject(HealthStoreViewModel())
            .environmentObject(FriendsViewModel())
            .environmentObject(HistoryViewModel())
    }
}
