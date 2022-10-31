//
//  AppDelegate.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 17/08/2022.
//

import SwiftUI
import Firebase
import FirebaseFunctions
import SwiftyBeaver
import HealthKit

class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    var userRepository: UserRepository
    var messagingService: MessagingService = MessagingService.shared
    
    override init() {
        self.userRepository = UserRepository.shared
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        UIApplication.shared.registerForRemoteNotifications()

        
        // Styling
        UITableView.appearance().backgroundColor = .clear
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.appleGreen)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white, .font: UIFont(name: Constants.mainFont, size: 16)!], for: [])
        
        UILabel.appearance().font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle(rawValue: Constants.mainFont))
        UITabBar.appearance().backgroundColor = .white
        UITabBarItem.appearance().setTitleTextAttributes([.font : UIFont(name: Constants.mainFont, size: 12)!], for: [])

        setToolBarTitleColor()
         
        let healthStoreService = HealthStoreService.shared
        if let healthstore = healthStoreService.healthStore {
            healthstore.enableBackgroundDelivery(for: HealthStoreService.HKDataTypes.stepCount, frequency: HKUpdateFrequency.immediate) { success, error in
                guard error == nil else {
                    Debug.log.error(error!.localizedDescription)
                    return
                }
            }
        }
        
        return true
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Debug.log.error("ERROR: \(error)")
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        MessagesViewModel.shared.getUserMessages()
        
        guard let userInfo = userInfo as NSDictionary? as? [String: Any] else {
            completionHandler(UIBackgroundFetchResult.newData)
            return
        }
        
        var message = NotificationMessage()
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcmToken = fcmToken {
            Debug.log.verbose("FCM TOKEN: \(fcmToken)")
            UserDefaultsService.shared.save(value: fcmToken, key: UserDefaultsKey.FCM_TOKEN)
                
            // TODO: Find more effective way to do this
            // Unsusbcribe from all group topics
            MessagingService.shared.unsubscribeFromAllTopics()
        }
        
        if let userID = getUserID(), let token = fcmToken {
            if UserService.shared.user.fcmToken == fcmToken { return }
            userRepository.doesUserExist(userID: userID) { userExists in
                guard let userExists = userExists else {
                    print("User does not exist so cannot set FCM Token")
                    return
                }
                if userExists {
                    self.userRepository.updateUser(userID: userID, updates: ["fcmToken": token]) {}
                }
            }
        }
    }
    
    // MARK: Notification Delegate Methods
    // This function will be called when the app receive notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        MessagesViewModel.shared.getUserMessages()
        // show the notification alert (banner), and with sound
        completionHandler([.banner,.sound])
    }
    
    // This function will be called right after user tap on the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        MessagesViewModel.shared.getUserMessages()
        // tell the app that we have finished processing the user’s action / response
        completionHandler()
    }
}
