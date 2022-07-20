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
    
    @StateObject var authViewModel = AuthenticationViewModel.shared
    @StateObject var appViewModel = AppViewModel.shared
    // To send notifications to user
    let notificationService: NotificationService = NotificationService()
    
    init() {
        FirebaseApp.configure()
        if let defaults = UserDefaults.standard.persistentDomain(forName: "empower.lab.community-garden-ios") {
            print(defaults)
        }
        
        defaultStyling()
    }
    
    func defaultStyling(){
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some Scene {
        WindowGroup {
            LaunchView()
            .environmentObject(authViewModel)
            .environmentObject(appViewModel)
        }
    }
}
