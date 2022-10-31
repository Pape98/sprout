//
//  NotificationService.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 1/3/22.
//

import Foundation
import UserNotifications

class NotificationService {
    
    var center: UNUserNotificationCenter
    static let shared = NotificationService()
    
    init() {
        // Request authorization to send local notifications (for reminder purposes)
        center = UNUserNotificationCenter.current()
        
        // Ask for permission
        center.requestAuthorization(options: [.alert, .badge, .sound]) { isGranted, error in
            guard error == nil else {
                Debug.log.error("requestAuthorizations()", error!)
                return
            }
        }
        
        setupHowAreYouNotification()
    }
    
    func sendNotification(message: NotificationMessage, interval: Double = 2.0) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = message.title
        notificationContent.body = message.body
        notificationContent.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval,
                                                        repeats: false)
        
        let request = UNNotificationRequest(identifier: "notification",
                                            content: notificationContent,
                                            trigger: trigger)
        
        center.add(request) { (error) in
            if let error = error {
                Debug.log.error("Notification Error: \(error)")
            }
        }
    }
    
    
    
    func setupHowAreYouNotification() {
        
        
        center.removeAllPendingNotificationRequests()
        
        // Step 1: Create the notification content
        let content = UNMutableNotificationContent()
        content.title = "Sprout"
        content.body = "Don't forget to check your tree 🌲 and flowers 🌷."
        content.sound = UNNotificationSound.default

        // Step 2: Create the notification trigger
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.hour = 12    // 12:00 hours, noon
        dateComponents.minute = 30
        dateComponents.second = 0
        dateComponents.nanosecond = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,
                                                    repeats: true)
        

        // Step 3: Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                                            content: content,
                                            trigger: trigger)

        // Step 4: Register with notification center
        center.add(request) { error in

            if let error = error {
                Debug.log.error("Notification Error: \(error)")
            }
        }
    }
}
 
