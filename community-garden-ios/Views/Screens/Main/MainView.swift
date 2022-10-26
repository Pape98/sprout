//
//  MainView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 28/06/2022.
//

import SwiftUI
import AVFoundation
import AlertToast

struct MainView: View {
    
    // MARK: View Models
    
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    @StateObject var healthStoreViewModel: HealthStoreViewModel = HealthStoreViewModel.shared
    @StateObject var userViewModel: UserViewModel = UserViewModel.shared
    @StateObject var gardenViewModel: GardenViewModel = GardenViewModel.shared
    @StateObject var messagesViewModel: MessagesViewModel = MessagesViewModel.shared
    @StateObject var historyViewModel: HistoryViewModel = HistoryViewModel.shared
    @StateObject var communityViewModel: CommunityViewModel = CommunityViewModel.shared
    @StateObject var badgesViewModel: BadgesViewModel = BadgesViewModel.shared
    
    let userDefaults = UserDefaultsService.shared
    let soundID:UInt32 = 1306
    
    var body: some View {
        
        ZStack {
            TabView {
                
                Dashboard()
                    .tabItem {
                        Label("Dashboard", systemImage: "house.fill")
                    }
                    .onAppear {
                        onAppearTabBarItem()
                    }
                
                
                if appViewModel.isSocialConfig {
                    Community()
                        .tabItem {
                            Label("Community", systemImage: "globe")
                        }
                        .onAppear {
                            SproutAnalytics.shared.viewCommunity()
                            onAppearTabBarItem()
                        }
                }
                if appViewModel.isSocialConfig {
                    
                    Badges()
                        .tabItem {
                            Label("Badges", systemImage: "book.fill")
                        }
                        .onAppear {
                            SproutAnalytics.shared.viewBadges()
                            appViewModel.setNumFiftyPercentDays()
                            onAppearTabBarItem()
                        }
                }
                
                History()
                    .tabItem {
                        Label("History", systemImage: "target")
                    }
                    .onAppear {
                        SproutAnalytics.shared.viewHistory()
                        onAppearTabBarItem()
                    }
                
                
                Settings()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape")
                    }
                    .onAppear {
                        onAppearTabBarItem()
                    }
            }
        }
        .toast(isPresenting: $appViewModel.showPointsGainedAlert, duration: 5, tapToDismiss: true, alert: {
            AlertToast(displayMode: .alert,
                       type: .image(appViewModel.alertImage, Color.green),
                       title: appViewModel.alertTitle, subTitle: appViewModel.alertSubtitle)
        })
        .toast(isPresenting: $healthStoreViewModel.showGoalCompletedAlert, duration: 5, tapToDismiss: true, alert: {
            AlertToast(displayMode: .alert,
                       type: .systemImage(healthStoreViewModel.goalCompletedAlertImage, .appleGreen),
                       title: "Goal Completed! ", subTitle: healthStoreViewModel.goalCompletedAlertSubtitle)
        })
        .accentColor(.appleGreen)
        .environmentObject(userViewModel)
        .environmentObject(healthStoreViewModel)
        .environmentObject(gardenViewModel)
        .environmentObject(messagesViewModel)
        .environmentObject(historyViewModel)
        .environmentObject(communityViewModel)
        .environmentObject(badgesViewModel)
    }
    
    func onAppearTabBarItem(){
        playSound()
        appViewModel.setBackground()
        appViewModel.setIntroBackground()
        appViewModel.isSocialConfigGroup()
        appViewModel.isCustomizationGroup()
        userViewModel.refreshStats()
        setToolBarTitleColor()
    }
    
    func playSound(){
        AudioPlayer.shared.playCustomSound(filename: "click1", volume: 0.5)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(UserViewModel())
            .environmentObject(HealthStoreViewModel())
            .environmentObject(HistoryViewModel())
            .environmentObject(CommunityViewModel())
            .environmentObject(AppViewModel())
            .environmentObject(AuthenticationViewModel())
    }
}
