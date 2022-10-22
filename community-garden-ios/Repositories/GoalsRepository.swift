//
//  GoalsRepository.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 11/10/2022.
//

import Foundation
import FirebaseFirestore
import Firebase

class GoalsRepository {
    static let shared = GoalsRepository()
    let collections = Collections.shared
    let db = Firestore.firestore()
    
    func updateGoalsAchieved(data: DataOptions, completion: @escaping () -> Void) {
        let collection = collections.getCollectionReference(CollectionName.goals.rawValue)
        guard let collection = collection else { return }
        let userGroup = UserService.shared.user.group
        let statRef = collection.document("\(userGroup)-\(Date.today)")
        
        db.runTransaction { (transaction, errorPointer) in
            let statDoc: DocumentSnapshot
            
            // Getting document
            do {
                try statDoc = transaction.getDocument(statRef)
            } catch {
                Debug.log.error(error)
                return
            }
            
            // Decoding document to GoalsStat
            
            var stat: GoalsStat
            
            do {
                 stat = try statDoc.data(as: GoalsStat.self)
            } catch {
                Debug.log.error(error)
                return nil
            }
            
            stat.numberOfGoalsAchieved += 1
            stat.trackedData.append(data.rawValue)
            
            do {
                try transaction.setData(from: stat, forDocument: statRef , merge: true)
            } catch {
                Debug.log.error(error)
                return nil
            }
            
            return nil
        } completion: { _ , err in
            
            if let err = err {
                Debug.log.error(err)
            }
            
            completion()
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
                // A `GoalStat` value was successfully initialized from the DocumentSnapshot.
                completion(goalsStat)
            case .failure(let error):
                // A `GoalStat` value could not be initialized from the DocumentSnapshot.
                Debug.log.error(error)
                docRef.setData(["date": Date.today,
                                "group": userGroup,
                                "trackedData": [],
                                "numberOfGoalsAchieved" : 0]){ err in
                    if let err = err {
                        Debug.log.error(err)
                        return
                    }
                    NotificationSender.send(type: NotificationType.FetchGoalStat.rawValue)
                }
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

