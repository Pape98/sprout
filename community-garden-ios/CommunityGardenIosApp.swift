//
//  community_garden_iosApp.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/3/21.
//

import SwiftUI
import Firebase

@main
struct CommunityGardenIosApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    @StateObject private var authViewModel = AuthenticationViewModel.shared
    @StateObject private var appViewModel = AppViewModel.shared
    // To send notifications to user
    let notificationService: NotificationService = NotificationService()
    
    init() {
//        if let defaults = UserDefaults.standard.persistentDomain(forName: "empower.lab.community-garden-ios") {
//            print(defaults)
//        }
        
    }

    var body: some Scene {
        WindowGroup {
            LaunchView()
                .background(Color.porcelain)
                .environmentObject(authViewModel)
                .environmentObject(appViewModel)
        }
    }
}

