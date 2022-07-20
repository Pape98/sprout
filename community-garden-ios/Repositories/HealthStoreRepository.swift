//
//  HealthStoreRepository2.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 11/07/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class HealthStoreRepository {
    
    enum Data: String {
        case sleep
        case steps
        case workouts
        case walkingRunning
    }
    
    // MARK: - Properties
    static let shared = HealthStoreRepository()
    let collections = Collections.shared
    let healthStoreService: HealthStoreService = HealthStoreService()
    let userID: String?
    let today = Date.today
    
    // MARK: - Methods
    init() {
        userID = Auth.auth().currentUser?.uid
        healthStoreService.setUpAuthorization()
    }
    
    // MARK: Saving data
    func saveStepCount(value v: Double){
        let object = Step(date: today, count: v, userID: userID!)
        let collection = collections.getCollectionReference(Data.steps.rawValue)
        guard let collection = collection else { return }
        let docRef = collection.document(getDocName())
        saveData(docRef: docRef, data: object, notification: NotificationType.FetchStepCount, message: v)
    }
    
    func saveWalkingRunningDistance(value v: Double){
        let object = WalkingRunningDistance(date: today, distance: v, userID: userID!)
        let collection = collections.getCollectionReference(Data.walkingRunning.rawValue)
        guard let collection = collection else { return }
        let docRef = collection.document(getDocName())
        saveData(docRef: docRef, data: object, notification: NotificationType.FetchWalkingRunningDistance, message: v)
    }
    
    func saveWorkouts(value v: Double){
        let object = Workout(date: today, duration: v, userID: userID!)
        let collection = collections.getCollectionReference(Data.workouts.rawValue)
        guard let collection = collection else { return }
        let docRef = collection.document(getDocName())
        saveData(docRef: docRef, data: object, notification: NotificationType.FetchWorkout, message: v)
    }
    
    func saveSleep(value v: Double){
        let object = Sleep(date: today, duration: v, userID: userID!)
        let collection = collections.getCollectionReference(Data.sleep.rawValue)
        guard let collection = collection else { return }
        let docRef = collection.document(getDocName())
        saveData(docRef: docRef, data: object, notification: NotificationType.FetchSleep, message: v)
    }
    
    
    // MARK: Retrieving data
    func getStepCountByDate(date: String, completion: @escaping (Step) -> Void) {
        getDataByDate(collectionName: Data.steps, date: date, type: Step.self) { result in
            completion(result)
        }
    }
    
    func getWalkingRunningDistanceByDate(date: String, completion: @escaping (WalkingRunningDistance) -> Void) {
        getDataByDate(collectionName: Data.walkingRunning, date: date, type: WalkingRunningDistance.self) { result in
            completion(result)
        }
    }
    
    func getWorkoutByDate(date: String, completion: @escaping (Workout) -> Void) {
        getDataByDate(collectionName: Data.workouts, date: date, type: Workout.self) { result in
            completion(result)
        }
    }
    
    func getSleepByDate(date: String, completion: @escaping (Sleep) -> Void) {
        getDataByDate(collectionName: Data.sleep, date: date, type: Sleep.self) { result in
            completion(result)
        }
    }
    
    
    // MARK: Utility Methods
    
    func getDocName() -> String {
        return "\(userID!)-\(today)"
    }
    
    func saveData<T: Encodable>(docRef: DocumentReference, data: T, notification: NotificationType, message: Double){
        do {
            try docRef.setData(from: data)
            NotificationSender.send(type: notification.rawValue, message: message)
        } catch {
            print("saveData: Error writing to Firestore: \(error)")
        }
    }
    
    func getDataByDate<T: Decodable>(collectionName name: Data, date: String, type: T.Type, completion: @escaping (T) -> Void) {
        let collection = collections.getCollectionReference(name.rawValue)
        guard let collection = collection else { return }
        let docRef = collection.document("\(userID!)-\(date)")
        docRef.getDocument(as: type) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print("Error getting \(name) to Firestore: \(error)")
            }
        }
    }
}
