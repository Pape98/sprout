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
    
    let subCollections: [String] = []
    let topLevelCollections = ["users","gardenItems","steps", "workouts", "walkingRunning", "sleep"]
    let nc = NotificationCenter.default
    
    var subCollectionsMap: Dictionary<String, CollectionReference> = [:]
    var toplevelCollectionsMap :Dictionary<String, CollectionReference> = [:]
    
    static let shared = Collections()
    static let today = Date.now.getFormattedDate(format: "MM-dd-yyyy")

    
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
                
        for name in topLevelCollections {
            toplevelCollectionsMap[name] = db.collection(name)
        }
        
        for name in subCollections {
            subCollectionsMap[name] = db.collection("users").document(userID).collection(name)
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
