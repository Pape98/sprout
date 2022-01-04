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
    

    
    func getData<T: Decodable>(userID: String, collectionName: String, objectType: T.Type, completion: @escaping ([T]) -> Void) {
        
        // Get document reference
        let userRef = Collections.shared.getCollectionReference("users").document(userID)
        
        var fetchedData = [T]()
        
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
                
                do {
                    let decodedObject: T? = try doc.data(as: T.self)
                    if let object = decodedObject {
                        fetchedData.append(object)
                    }
                    
                } catch {
                    print("[getUserSteps()]", error)
                }
            }
                        
            completion(fetchedData)
        }
    }
}
