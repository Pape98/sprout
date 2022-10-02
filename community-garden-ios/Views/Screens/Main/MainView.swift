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
    @StateObject var gardenViewModel: GardenViewModel = GardenViewModel.shared
    @StateObject var messagesViewModel: MessagesViewModel = MessagesViewModel.shared
    @StateObject var historyViewModel: HistoryViewModel = HistoryViewModel.shared
    @StateObject var communityViewModel: CommunityViewModel = CommunityViewModel.shared
    
    let userDefaults = UserDefaultsService.shared
    let soundID:UInt32 = 1306
    
    var body: some View {
        
        ZStack {
            TabView {
                
    //            if RemoteConfiguration.shared.isSocialConfig(group: UserService.user.group){
    //                Community()
    //                    .tabItem {
    //                        Label("Community", systemImage: "globe")
    //                    }
    //                    .onAppear {
    //                        playSound()
    //                    }
    //            }

                
                Dashboard()
                    .tabItem {
                        Label("Dashboard", systemImage: "house.fill")
                    }
                    .onAppear {
                        playSound()
                    }

                if RemoteConfiguration.shared.isSocialConfig(group: UserService.user.group){
                    Community()
                        .tabItem {
                            Label("Community", systemImage: "globe")
                        }
                        .onAppear {
                            playSound()
                        }
                }

                History()
                    .tabItem {
                        Label("History", systemImage: "target")
                    }
                    .onAppear {
                        SproutAnalytics.shared.viewHistory()
                        playSound()
                    }

                if RemoteConfiguration.shared.canCustomize(group: UserService.user.group){
                    Settings()
                        .tabItem {
                            Label("Settings", systemImage: "gearshape")
                        }
                        .onAppear {
                            playSound()
                        }
                }
            }
        }
        .accentColor(.appleGreen)
        .environmentObject(userViewModel)
        .environmentObject(healthStoreViewModel)
        .environmentObject(gardenViewModel)
        .environmentObject(messagesViewModel)
        .environmentObject(historyViewModel)
        .environmentObject(communityViewModel)
    }
    
    func playSound(){
        AudioPlayer.shared.playCustomSound(filename: "click1.mp3", volume: 0.5)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(UserViewModel())
            .environmentObject(HealthStoreViewModel())
            .environmentObject(HistoryViewModel())
            .environmentObject(CommunityViewModel())
    }
}
