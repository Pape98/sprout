//
//  CollectionService.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 1/4/22.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class Collections {
    
    let db: Firestore
    
    let subCollections: [String] = ["messages"]
    let topLevelCollections = ["users","gardenItems","steps", "workouts", "walkingRunning", "sleep"]
    let nc = NotificationCenter.default
    
    var subCollectionsMap: Dictionary<String, CollectionReference> = [:]
    var toplevelCollectionsMap :Dictionary<String, CollectionReference> = [:]
    
    static let shared = Collections()
    static let today = Date.today
    
    init() {
        db = Firestore.firestore()
        setupCollections()
        nc.addObserver(self,
                       selector: #selector(setupCollections),
                       name: Notification.Name(NotificationType.UserLoggedIn.rawValue),
                       object: nil)
    }
    
    @objc func setupCollections(){
        guard let user = Auth.auth().currentUser else { return }
        let userID = user.uid
                
        for name in CollectionName.topLevelCollections {
            toplevelCollectionsMap[name.rawValue] = db.collection(name.rawValue)
        }
        
        for name in CollectionName.subCollections {
            subCollectionsMap[name.rawValue] = db.collection(CollectionName.users.rawValue).document(userID).collection(name.rawValue)
        }
    }
    
    func getCollectionReference(_ collectionName: String) -> CollectionReference? {
        if toplevelCollectionsMap[collectionName] != nil {
            return toplevelCollectionsMap[collectionName]!
        } else if subCollectionsMap[collectionName] != nil{
            return subCollectionsMap[collectionName]!
        }
        return nil
    }
}

enum CollectionName: String, CaseIterable {
    case users
    case gardenItems
    case steps
    case workouts
    case walkingRunning
    case sleep
    
    static var topLevelCollections: [CollectionName] {
        [users, gardenItems, steps, workouts, walkingRunning, sleep]
    }
    
    static var subCollections: [CollectionName] {
        []
    }
}

enum FirestoreKey: String {
    // Onboarding
    case TREE = "tree"
    case TREE_COLOR = "treeColor"
    case FLOWER = "flower"
    case FLOWER_COLOR = "flowerColor"
    case DATA = "data"
    case STEPS_GOAL = "stepsGoal"
    case SLEEP_GOAL = "sleepGoal"
    case WORKOUT_GOAL = "workoutsGoal"
    case WALKING_RUNNING_GOAL = "walkingRunningGoal"
    case MAPPED_DATA = "mappedData"
    case GARDEN_NAME = "gardenName"
    case REFLECT_WEATHER_CHANGES = "reflectWeatherChanges"
    case IS_NEW_USER = "isNewUser"
}
