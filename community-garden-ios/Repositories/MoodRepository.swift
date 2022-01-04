//
//  StepRepository.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 1/4/22.
//

import Foundation
import FirebaseFirestore

class MoodRepository {
    
    // MARK: - Properties
    
    let db: Firestore
    let moodsCollection: CollectionReference
    static let shared = MoodRepository() // Single repo instance shared

    
    // MARK: - Methods
    
    init() {
        
        // Get a reference to database
        db = Firestore.firestore()
        
        // Get collection references
        moodsCollection = db.collection(Constants.Collection.moods.rawValue)
    }
    
    // MARK: - Methods
    
    func addMood(_ mood: Mood, completion: @escaping () -> Void) {
        
        do {
            try moodsCollection.document().setData(from: mood){ error in
                print("HERE", error)
                completion()
            }
        } catch {
            print("Error writing document: \(error)")
        }
    }
    
    func getMoodEntries(userId: String, completion: @escaping ([Mood]) -> Void) {
        
        var currentUserMoods = [Mood]()
                
        moodsCollection
            .whereField("userId", isEqualTo: userId)
            .order(by: "date", descending: true)
            .getDocuments { snapshot, error in
                
                guard error == nil else {
                    print("[getUserData()]", error!)
                    return
                }
                
                for doc in snapshot!.documents {
                    
                    var mood = Mood()
                    mood.id = doc["id"] as? String ?? ""
                    mood.text = doc["text"] as? String ?? ""
                    mood.userId = doc["userId"] as? String ?? ""
                    
                    let date = doc["date"] as? Timestamp ?? nil
                    mood.date = date?.dateValue()
                    
                    currentUserMoods.append(mood)
                }
                
                completion(currentUserMoods)
        }
        
    }
}
