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
    
    @StateObject var authModel = AuthenticationViewModel.shared
    
    // To send notifications to user
    let notificationService: NotificationService = NotificationService()
    
    init() {
        UIApplication.shared.registerForRemoteNotifications()
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LaunchView().onAppear(){
                authModel.checkLogin()
            }
            .environmentObject(authModel)
        }
    }
}
