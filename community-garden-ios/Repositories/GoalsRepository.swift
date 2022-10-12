//
//  GoalsRepository.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 11/10/2022.
//

import Foundation
import FirebaseFirestore

class GoalsRepository {
    static let shared = GoalsRepository()
    let collections = Collections.shared
    
    func updateGoalsAchieved(data: DataOptions){
        let collection = collections.getCollectionReference(CollectionName.goals.rawValue)
        guard let collection = collection else { return }
        let userGroup = UserService.shared.user.group
        let docRef = collection.document("\(userGroup)-\(Date.today)")
        docRef.setData(["date": Date.today,
                        "group": userGroup,
                        "trackedData": FieldValue.arrayUnion([data.rawValue]),
                        "numberOfGoalsAchieved" : FieldValue.increment(Int64(1))], merge: true){_ in }
    }
    
    func getGoalsStatByDate(date: String, completion: @escaping (GoalsStat) -> Void){
        let collection = collections.getCollectionReference(CollectionName.goals.rawValue)
        guard let collection = collection else { return }
        let userGroup = UserService.shared.user.group
        let docRef = collection.document("\(userGroup)-\(Date.today)")        
        docRef.getDocument(as: GoalsStat.self) { result in
                        
            switch result {
            case .success(let goalsStat):
                // A `City` value was successfully initialized from the DocumentSnapshot.
                completion(goalsStat)
            case .failure(let error):
                // A `City` value could not be initialized from the DocumentSnapshot.
                Debug.log.error("Error decoding goalsStat: \(error)")
            }
        }
    }
}

