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
        
        getGoalsStatByDate(date: Date.today) { stat in
            var trackedData = stat.trackedData
            trackedData.append(data.rawValue)
            docRef.setData(["date": Date.today,
                            "group": userGroup,
                            "trackedData": trackedData,
                            "numberOfGoalsAchieved" : FieldValue.increment(Int64(1))], merge: true){_ in }
        }
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
    
    func getAllGoalsStat(query: Query, completion: @escaping ([GoalsStat]) -> Void){
        let collection = collections.getCollectionReference(CollectionName.goals.rawValue)
        guard let collection = collection else { return }
        
        query.getDocuments { querySnapshot, error in
            if let error = error {
                Debug.log.error("Error getting documents: \(error)")
            } else {
                var stats:[GoalsStat] = []
                for document in querySnapshot!.documents {
                    
                    do {
                        let decodedStat: GoalsStat = try document.data(as: GoalsStat.self)
                        stats.append(decodedStat)
                    } catch {
                        Debug.log.error("[getAllGoalsStat()]: \(error)")
                        
                    }
                }
                completion(stats)
            }
        }
        
        
    }
}

