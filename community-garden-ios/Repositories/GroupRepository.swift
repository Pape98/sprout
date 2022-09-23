//
//  GroupsRepository.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 18/09/2022.
//

import Foundation
import FirebaseFirestore

class GroupRepository {
    static let shared = GroupRepository()
    let collections = Collections.shared
    let groupsCollection: CollectionReference?
    
    init(){
        // Get collection references
        groupsCollection = collections.db.collection(CollectionName.groups.rawValue)
    }
    
    func createGroup(groupNumber: Int, completion: @escaping(_: GardenGroup) -> Void){
        let group = GardenGroup(id: groupNumber)
        
        guard let groupsCollection = groupsCollection else { return }
        
        do {
            try groupsCollection.document(String(groupNumber)).setData(from: group)
        } catch let err {
            print("[createNewUser()]","Error writing document: \(err)")
        }
    }
    
    func fetchGroup(groupNumber: Int , completion: @escaping(_: GardenGroup) -> Void){
        guard let groupsCollection = groupsCollection else { return }
        // Get document reference
        let groupRef = groupsCollection.document(String(groupNumber))
        
        groupRef.getDocument { document, error in
                        
            guard error == nil else {
                print("[fetchGroup()]", error!)
                return
            }
            
            // case group does not exist
            if document!.data() == nil {
                self.createGroup(groupNumber: groupNumber) {_ in
                    self.fetchGroup(groupNumber: groupNumber, completion: completion)
                }
                return
            }
            
            do {
                let decodedGroup: GardenGroup = try document!.data(as: GardenGroup.self)
                completion(decodedGroup)
            } catch {
                print("[fetchGroup() decoding]", error)
            }
        }
    }
}
