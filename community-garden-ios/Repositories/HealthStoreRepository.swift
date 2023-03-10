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
    let appGroup = AppGroupService.shared
    let healthStoreService: HealthStoreService = HealthStoreService.shared
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
        guard let goal = settings.stepsGoal else { return }
        let user = UserService.shared.user
        let updates: [String: Any] = ["date": today,
                                      "count": v,
                                      "userID": userID!,
                                      "goal": goal as Any,
                                      "username": user.name,
                                      "group": user.group]
                
        let collection = collections.getCollectionReference(Data.steps.rawValue)
        guard let collection = collection else { return }
        let docRef = collection.document(getDocName())
        saveData(docRef: docRef, updates: updates){
            NotificationSender.send(type: NotificationType.FetchStepCount.rawValue, message: v)
        }
    }
    
    func saveWalkingRunningDistance(value v: Double){
        guard let settings = UserService.shared.user.settings else { return }
        guard let goal = settings.walkingRunningGoal else { return }
        let user = UserService.shared.user
        let updates: [String: Any] = ["date": today,
                                      "distance": v,
                                      "userID": userID!,
                                      "goal": goal as Any,
                                      "username": user.name,
                                      "group": user.group]
        
        let collection = collections.getCollectionReference(Data.walkingRunning.rawValue)
        guard let collection = collection else { return }
        let docRef = collection.document(getDocName())
        saveData(docRef: docRef, updates: updates){
            NotificationSender.send(type: NotificationType.FetchWalkingRunningDistance.rawValue, message: v)
        }
    }
    
    func saveWorkouts(value v: Double){
        guard let settings = UserService.shared.user.settings else { return }
        guard let goal = settings.workoutsGoal else { return }
        let user = UserService.shared.user
        let updates: [String: Any] = ["date": today,
                                      "duration": v,
                                      "userID": userID!,
                                      "goal": goal as Any,
                                      "username": user.name,
                                      "group": user.group]
        
        let collection = collections.getCollectionReference(Data.workouts.rawValue)
        guard let collection = collection else { return }
        let docRef = collection.document(getDocName())
        saveData(docRef: docRef, updates: updates){
            NotificationSender.send(type: NotificationType.FetchWorkout.rawValue, message: v)
        }
    }
    
    func saveSleep(value v: Double){
        guard let settings = UserService.shared.user.settings else { return }
        guard let goal = settings.sleepGoal else { return }
        let user = UserService.shared.user
        let updates: [String: Any] = ["date": today,
                                      "duration": v,
                                      "userID": userID!,
                                      "goal": goal as Any,
                                      "username": user.name,
                                      "group": user.group]
        
        let collection = collections.getCollectionReference(Data.sleep.rawValue)
        guard let collection = collection else { return }
        let docRef = collection.document(getDocName())
        saveData(docRef: docRef, updates: updates){
            NotificationSender.send(type: NotificationType.FetchSleep.rawValue, message: v)
        }
    }
    
    
    // MARK: Retrieving data
    func getStepCountByDate(date: String, completion: @escaping (Step) -> Void) {
        getDataByDate(collectionName: Data.steps, date: date, type: Step.self) { result in
            guard let result = result else {
                self.saveProgressDataAppGroup("steps",0)
                return
            }
            completion(result)
        }
    }
    
    func getWalkingRunningDistanceByDate(date: String, completion: @escaping (WalkingRunningDistance) -> Void) {
        getDataByDate(collectionName: Data.walkingRunning, date: date, type: WalkingRunningDistance.self) { result in
            guard let result = result else {
                self.saveProgressDataAppGroup("walkingRunning",0)
                return
            }
            completion(result)
        }
    }
    
    func getWorkoutByDate(date: String, completion: @escaping (Workout) -> Void) {
        getDataByDate(collectionName: Data.workouts, date: date, type: Workout.self) { result in
            guard let result = result else {
                self.saveProgressDataAppGroup("workouts",0)
                return
            }
            completion(result)
        }
    }
    
    func getSleepByDate(date: String, completion: @escaping (Sleep) -> Void) {
        getDataByDate(collectionName: Data.sleep, date: date, type: Sleep.self) { result in
            guard let result = result else {
                self.saveProgressDataAppGroup("sleep",0)
                return
            }
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
    
    func saveProgressDataAppGroup(_ key: String, _ value: Float){
        var currProgress: [String: Float] = appGroup.get(key: AppGroupKey.progressData)
        currProgress[key] = value
        appGroup.save(value: currProgress, key: AppGroupKey.progressData)
    }
    
    func getDocName() -> String {
        return "\(userID!)-\(today)"
    }
    
    func saveData(docRef: DocumentReference, updates: [String: Any], completion: @escaping () -> Void){
        docRef.setData(updates, merge: true) { err in
            if let err = err {
                Debug.log.error("Error saving data to Firestore: \(err)")
            } else {
                completion()
            }
        }
    }
    
//    func saveData<T: Encodable>(docRef: DocumentReference, data: T, notification: NotificationType, message: Double){
//        do {
//            try docRef.setData(from: data, merge: true)
//            NotificationSender.send(type: notification.rawValue, message: message)
//        } catch {
//            Debug.log.error("Error saving data to Firestore: \(error)")
//        }
//    }
    
    func getDataByDate<T: Decodable>(collectionName name: Data, date: String, type: T.Type, completion: @escaping (T?) -> Void) {
        let collection = collections.getCollectionReference(name.rawValue)
        guard let collection = collection else { return }
        let docRef = collection.document("\(userID!)-\(date)")
                
        docRef.getDocument(as: type) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                Debug.log.error("\(name) for \(date) does not exist: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    func getData<T: Codable>(collectionName name: Data, type: T.Type, completion: @escaping ([T]) -> Void) {
        let collection = collections.getCollectionReference(name.rawValue)
        guard let collection = collection else { return }
        
        let docRef = collection.whereField("userID", isEqualTo: userID!).whereField("date", isNotEqualTo: Date.today).order(by: "date", descending: true)
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
                    Debug.log.error("getData: Error reading from Firestore for \(name): \(error)")
                }
                
                completion(res)
            }
        }
    }
}
