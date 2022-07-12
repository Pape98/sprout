//
//  HealthStoreRepository2.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 11/07/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class HealthStoreRepository2 {
    
    // MARK: - Properties
    static let shared = HealthStoreRepository2()
    let collections = Collections.shared
    let stepsCollection: CollectionReference
    let userID: String
    let today = Date.now.getFormattedDate(format: "MM-dd-yyyy")
    let STEPS_COLLECTION = "steps"
    
    // MARK: - Methods
    
    init() {
        stepsCollection = Collections.shared.getCollectionReference(STEPS_COLLECTION)
        userID = Auth.auth().currentUser!.uid
    }
    
    // MARK: Saving data to tables
    func saveStepCount(value v: Double){
        let step = Step(date: today, count: v)
        let docRef = stepsCollection.document(docName(today))
        do {
            try docRef.setData(from: step)
            NotificationSender.send(type: NotificationType.FetchStepCount.rawValue, message: v)
        } catch {
            print("Error writing step to Firestore: \(error)")
        }
    }
    
    func getStepCountByDate(date: String, completion: @escaping (Step) -> Void) {
        getDataByDate(collectionName: "steps", date: date, type: Step.self) { result in
            completion(result)
        }
    }
    
    func getDataByDate<T: Decodable>(collectionName name: String, date: String, type: T.Type, completion: @escaping (T) -> Void) {
        let docRef = collections.getCollectionReference(name).document(docName(date))
        docRef.getDocument(as: type) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print("Error writing \(name) to Firestore: \(error)")
            }
        }
    }
    
    
    // MARK: Utility Methods
    func docName(_ date: String) -> String {
        return   "\(userID)\(date)"
    }
    
    
}
