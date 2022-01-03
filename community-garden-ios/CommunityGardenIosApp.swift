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
    
    @StateObject var authModel: AuthenticationViewModel = AuthenticationViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(authModel)
        }
    }
}
