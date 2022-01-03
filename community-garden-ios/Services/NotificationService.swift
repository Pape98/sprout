//
//  NotificationService.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 1/3/22.
//

import Foundation
import UserNotifications

class NotificationService {
    
    init() {
        // Request authorization to send local notifications (for reminder purposes)
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound]) { isGranted, error in
            
            guard error == nil else {
                print("requestAuthorizations()", error!)
                return
            }
        }
    }
}
