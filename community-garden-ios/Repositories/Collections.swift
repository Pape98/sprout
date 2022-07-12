//
//  CollectionService.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 1/4/22.
//

import Foundation
import FirebaseFirestore

class Collections {
    
    let collectionNames = ["users", "steps"]
    var collectionReferences: Dictionary<String, CollectionReference> = [:]
    static let shared = Collections()
    
    init() {
        let db = Firestore.firestore()
        for name in collectionNames {
            collectionReferences[name] = db.collection(name)
        }
    }
    
    func getCollectionReference(_ collectionName: String) -> CollectionReference {
            return collectionReferences[collectionName]!
    }
}
