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
        moodsCollection = Collections.shared.getCollectionReference("moods")
    }
    
    // MARK: - Methods
    
    func addMood(_ mood: Mood, completion: @escaping () -> Void) {
        
        do {
            try moodsCollection.document().setData(from: mood){ error in
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
                    
                    do {
                        let mood: Mood? = try doc.data(as: Mood.self)
                        if let mood = mood {
                            currentUserMoods.append(mood)
                        }
                    } catch {
                        print("[getMoodEntries()]", error)
                    }
                }
                
                completion(currentUserMoods)
        }
        
    }
}
