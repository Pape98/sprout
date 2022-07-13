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
    
    
    func addItem(item: GardenItem){
        let collection = collections.getCollectionReference("gardenItems")
        guard let collection = collection else { return }
        let docRef = collection.document(docName(item: item))
        saveData(docRef: docRef, data: item)
    }
    
    func getItems(completion: @escaping ([GardenItem]) -> Void){
        let collection = collections.getCollectionReference("gardenItems")
        guard let collection = collection else { return }
        collection.getDocuments { querySnapshot, error in
            
            if error != nil {
                print("getItems: Error writing to Firestore: \(error!)")
                return
            }
            
            var items: [GardenItem] = []
            
            do {
                for doc in querySnapshot!.documents {
                    items.append(try doc.data(as: GardenItem.self))
                }
            } catch {
                print("getItems: Error writing to Firestore: \(error)")
            }
            
            completion(items)
        }
    }
    
    func udpateGardenItem(docName: String, updates: GardenItem){
        let collection = collections.getCollectionReference("gardenItems")
        guard let collection = collection else { return }
        let docRef = collection.document(docName)
        saveData(docRef: docRef, data: updates)
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
        if item.type == GardenItemType.tree {
            return "tree"
        }
        return "\(item.type)-\(item.id)"
    }
}
