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
        var item = item
        let collection = collections.getCollectionReference(CollectionName.gardenItems.rawValue)
        guard let collection = collection else { return }
        let documentName = UUID().uuidString
        let docRef = collection.document(documentName)
        item.documentName = documentName
        saveData(docRef: docRef, data: item)
    }
    
    func getUserItems(query: Query , completion: @escaping ([GardenItem]) -> Void){
        query.getDocuments { querySnapshot, error in
            
            if error != nil {
                print("getUserItems: Error reading from Firestore: \(error!)")
                return
            }
            
            var items: [GardenItem] = []
            
            do {
                for doc in querySnapshot!.documents {
                    items.append(try doc.data(as: GardenItem.self))
                }
            } catch {
                print("getUserItems: Error reading from Firestore: \(error)")
            }
            
            completion(items)
        }
    }
    
    // TODO: Run in transaction or use FieldValue
    func udpateGardenItem(docName: String, updates: GardenItem, completion: @escaping () -> Void){
        let collection = collections.getCollectionReference(CollectionName.gardenItems.rawValue)
        guard let collection = collection else { return }
        let docRef = collection.document(docName)
        saveData(docRef: docRef, data: updates)
        completion()
    }
    
    
    // MARK: Utility Methods
    func saveData<T: Encodable>(docRef: DocumentReference, data: T){
        do {
            try docRef.setData(from: data, merge: true)
        } catch {
            print("saveData: Error writing to Firestore: \(error)")
        }
    }
    
    func docName(item: GardenItem) -> String {
        let name = "\(item.type.rawValue)-\(getUserID()!)-\(today)"
        return name
    }
    
}
