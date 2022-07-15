//
//  GardenRepository.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 13/07/2022.
//

import Foundation
import FirebaseFirestore

class GardenRepository {
    static let shared = GardenRepository()
    let collections = Collections.shared
    let today = Date.today
    let userRepo = UserRepository.shared
    
    
    func addItem(item: GardenItem){
        let collection = collections.getCollectionReference(CollectionName.gardenItems.rawValue)
        guard let collection = collection else { return }
        let docRef = collection.document(UUID().uuidString)
        saveData(docRef: docRef, data: item)
    }
    
    func getUserItems(query: Query , completion: @escaping ([GardenItem]) -> Void){
        query.getDocuments { querySnapshot, error in
            
            if error != nil {
                print("getUserItems: Error writing to Firestore: \(error!)")
                return
            }
            
            var items: [GardenItem] = []
            
            do {
                for doc in querySnapshot!.documents {
                    items.append(try doc.data(as: GardenItem.self))
                }
            } catch {
                print("getUserItems: Error writing to Firestore: \(error)")
            }
            
            completion(items)
        }
    }
    
    func udpateGardenItem(docName: String, updates: GardenItem){
        let collection = collections.getCollectionReference(CollectionName.gardenItems.rawValue)
        guard let collection = collection else { return }
        let docRef = collection.document(docName)
        saveData(docRef: docRef, data: updates)
    }
    
    func resetFlowers(){
        let collection = collections.getCollectionReference("gardenItems")
        guard let collection = collection else { return }
        let query = collection.whereField("type", isEqualTo: "flower")
        query.getDocuments { querySnapshot, error in
            if error != nil {
                print("getItems: Error writing to Firestore: \(error!)")
                return
            }
            for doc in querySnapshot!.documents {
                doc.reference.delete()
            }
        }
    }
    
    // MARK: Utility Methods
    func saveData<T: Encodable>(docRef: DocumentReference, data: T){
        do {
            try docRef.setData(from: data)
        } catch {
            print("saveData: Error writing to Firestore: \(error)")
        }
    }
    
    func docName(item: GardenItem) -> String {
        let name = "\(item.type.rawValue)-\(getUserID()!)-\(today)"
        return name
    }
    
}
