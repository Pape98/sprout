//
//  HealthStoreRepository.swift
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
        guard let settings = UserService.shared.user.settings else { return }
        let goal = settings.stepsGoal
        let user = UserService.shared.user
        var object = Step(date: today, count: v, userID: userID!, goal: goal, username: user.name, group: user.group)
        
        if let goal = goal {
            object.hasReachedGoal = v >= Double(goal) ? true : false
        }
        
        let collection = collections.getCollectionReference(Data.steps.rawValue)
        guard let collection = collection else { return }
        let docRef = collection.document(getDocName())
        saveData(docRef: docRef, data: object, notification: NotificationType.FetchStepCount, message: v)
    }
    
    func saveWalkingRunningDistance(value v: Double){
        guard let settings = UserService.shared.user.settings else { return }
        let goal = settings.walkingRunningGoal
        let user = UserService.shared.user
        var object = WalkingRunningDistance(date: today, distance: v, userID: userID!, goal: goal, username: user.name, group: user.group)
        
        if let goal = goal {
            object.hasReachedGoal = v >= Double(goal) ? true : false
        }
        
        let collection = collections.getCollectionReference(Data.walkingRunning.rawValue)
        guard let collection = collection else { return }
        let docRef = collection.document(getDocName())
        saveData(docRef: docRef, data: object, notification: NotificationType.FetchWalkingRunningDistance, message: v)
    }
    
    func saveWorkouts(value v: Double){
        guard let settings = UserService.shared.user.settings else { return }
        let goal = settings.workoutsGoal
        let user = UserService.shared.user
        var object = Workout(date: today, duration: v, userID: userID!,goal: goal, username: user.name, group: user.group)
        
        if let goal = goal {
            object.hasReachedGoal = v >= Double(goal) ? true : false
        }
        
        let collection = collections.getCollectionReference(Data.workouts.rawValue)
        guard let collection = collection else { return }
        let docRef = collection.document(getDocName())
        saveData(docRef: docRef, data: object, notification: NotificationType.FetchWorkout, message: v)
    }
    
    func saveSleep(value v: Double){
        guard let settings = UserService.shared.user.settings else { return }
        let goal = settings.sleepGoal
        let user = UserService.shared.user
        var object = Sleep(date: today, duration: v, userID: userID!,goal: goal, username: user.name, group: user.group)
        
        if let goal = goal {
            object.hasReachedGoal = v >= Double(goal) ? true : false
        }
        
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
    
    func getAllStepCount(completion: @escaping ([Step]) -> Void){
        getData(collectionName: Data.steps, type: Step.self) { result in
            completion(result)
        }
    }
    
    func getAllSleep(completion: @escaping ([Sleep]) -> Void){
        getData(collectionName: Data.sleep, type: Sleep.self) { result in
            completion(result)
        }
    }
    
    func getAllWorkouts(completion: @escaping ([Workout]) -> Void){
        getData(collectionName: Data.workouts, type: Workout.self) { result in
            completion(result)
        }
    }
    
    func getAllWalkingRunning(completion: @escaping ([WalkingRunningDistance]) -> Void){
        getData(collectionName: Data.walkingRunning, type: WalkingRunningDistance.self) { result in
            completion(result)
        }
    }
    
    
    // MARK: Utility Methods
    
    func getDocName() -> String {
        return "\(userID!)-\(today)"
    }
    
    func saveData<T: Encodable>(docRef: DocumentReference, data: T, notification: NotificationType, message: Double){
        do {
            try docRef.setData(from: data, merge: true)
            NotificationSender.send(type: notification.rawValue, message: message)
        } catch {
            Debug.log.error("Error saving data to Firestore: \(error)")
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
                Debug.log.error("Error getting \(name) from Firestore: \(error)")
            }
        }
    }
    
    func getData<T: Codable>(collectionName name: Data, type: T.Type, completion: @escaping ([T]) -> Void) {
        let collection = collections.getCollectionReference(name.rawValue)
        guard let collection = collection else { return }
        
        let docRef = collection.whereField("userID", isEqualTo: userID!).order(by: "date", descending: true)
        var res :  [T] = []
        
        docRef.getDocuments() {(snapshot, err) in
            if let err = err {
                Debug.log.error("Error getting documents: \(err)")
            } else {
                do {
                    for doc in snapshot!.documents {
                        res.append(try doc.data(as: type))
                    }
                } catch {
                    Debug.log.error("getData: Error reading from Firestore: \(error)")
                }
                
                completion(res)
            }
        }
    }
}
