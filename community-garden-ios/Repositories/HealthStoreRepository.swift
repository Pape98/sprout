//
//  HealthstoreRepository.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 1/4/22.
//

import Foundation
import FirebaseFirestore

class HealthStoreRepository {
    
    // MARK: Properties
    static let shared = HealthStoreRepository()
    let db: Firestore
    
    // MARK: Methods
    init() {
        
        // Get a reference to database
        db = Firestore.firestore()
    }
    
    func updateUserTrackedData(userID: String, collectionName: String, update: [String: Any], completion: @escaping () -> Void) {
        
        // Get document reference
        let userRef = Collections.shared.getCollectionReference("users").document(userID)

        guard let date = update["date"] as? Date else { return }

        // Perform update operation
        userRef
            .collection("steps")
            .document(date.getFormattedDate(format: "MM-dd-YYYY"))
            .setData(update)

        completion()
    }
    
    func getUserSteps(userID: String, collectionName: String, completion: @escaping ([Step]) -> Void) {
        
        // Get document reference
        let userRef = Collections.shared.getCollectionReference("users").document(userID)
        
        var fetchedData = [Step]()
        
        // Get a reference to the subcollection for data
        let subCollection = userRef
            .collection(collectionName)
            .order(by: "date", descending: true)
        
        subCollection.getDocuments { snapshot, error in
            
            guard error == nil else {
                print("[getUserData()]", error!)
                return
            }
            
            for doc in snapshot!.documents {
                
                // TODO: Generalize to accept other data

                
                let item = Step()
                item.count = doc["count"] as? Int ?? 0
                                
                let date = doc["date"] as? Timestamp ?? nil
                
                if let dateValue = date {
                    item.date = dateValue.dateValue()
                }
                
                fetchedData.append(item)
            }
                        
            completion(fetchedData)
        }
    }
}
