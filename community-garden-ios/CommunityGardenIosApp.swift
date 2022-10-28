//
//  community_garden_iosApp.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/3/21.
//

import SwiftUI
import Firebase
import FirebaseFunctions
import FirebaseAnalytics

@main
struct CommunityGardenIosApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject private var authViewModel = AuthenticationViewModel.shared
    @StateObject private var appViewModel = AppViewModel.shared
    let constants : Constants = Constants.shared
    
    
    let hour = Int(Date.hour)
    
    // To send notifications to user
    let notificationService: NotificationService = NotificationService.shared
    
    var fontColor: Color {
        let weather = getWeatherInfo()
        
        if weather["color"]! == "evening"{
            return Color.black
        }
        
        return Color.black
    }
    
    init() {
        if let defaults = UserDefaults.standard.persistentDomain(forName: "empower.lab.sprout-ios") {
            Debug.log.info(defaults)
        }
        
        FirebaseApp.configure()
        RemoteConfiguration.shared.fetchRemoteConfig()
        
        if Platform.isSimulator {
            setupLocalEmulator()
        }
    }
    
    func setupLocalEmulator(){
        
        // Local firestore
        let settings = Firestore.firestore().settings
        settings.host = "localhost:8080"
        settings.isPersistenceEnabled = false
        settings.isSSLEnabled = false
        Firestore.firestore().settings = settings
        
        // Cloud Functions
        Functions.functions().useEmulator(withHost: "http://localhost", port:5001)
    }
    
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .font(Font.custom(Constants.mainFont, size: 18))
                .foregroundColor(fontColor)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification), perform: { _ in
                    SproutAnalytics.shared.setDefaultParams()
                })
                .background(Color.porcelain)
                .environmentObject(authViewModel)
                .environmentObject(appViewModel)
                .onAppear {
                    RemoteConfiguration.shared.fetchRemoteConfig()
                    UserViewModel.shared.getNumSeeds()
                    UserViewModel.shared.refreshStats()
                }
                .onChange(of: scenePhase) { newPhase in
                    
                    if newPhase == .active {
                        UserViewModel.shared.getNumSeeds()
                        UserViewModel.shared.getNumDroplets()
                        AudioPlayer.shared.startBackgroundMusic()
                        // Get anaylytics if user is logged in
                        Analytics.setAnalyticsCollectionEnabled(isUserLoggedIn())
                        
                    }
                    else {
                        AudioPlayer.shared.stopBackgroundMusic()
                    }
                    
                    RemoteConfiguration.shared.fetchRemoteConfig()
                    appViewModel.setBackground()
                }
        }
    }
}

