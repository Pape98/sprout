//
//  NotificationSender.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 5/24/22.
//

import Foundation


enum NotificationType: String {
    case UserLoggedIn
    case FetchUser
    case FetchStepCount
    case FetchWalkingRunningDistance
    case FetchWorkout
    case FetchSleep
}

class NotificationSender {
    
    static func send(type: String){
        NotificationCenter.default.post(name: Notification.Name(type), object: nil)
    }
}
