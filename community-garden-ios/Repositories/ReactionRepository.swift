//
//  ReactionsRepository.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 26/09/2022.
//

import Foundation
import FirebaseFirestore

enum ReactionType: String {
    case love
}

class ReactioRepository: ObservableObject {
    static let shared = ReactioRepository()
    let collections = Collections.shared
    let reactionsCollection: CollectionReference?
    
    init(){
        // Get collection references
        reactionsCollection = collections.db.collection(CollectionName.reactions.rawValue)
    }
    
    func increaseReactionCount(reaction: ReactionType, tokens: [String], callback: () -> Void){
        guard let reactionsCollection = reactionsCollection else { return }
        let userGroup = UserService.user.group
        let docRef = reactionsCollection.document("\(userGroup)-\(Date.today)")
        docRef.setData(["date": Date.today,
                        "group": userGroup,
                        "tokens": tokens,
                        reaction.rawValue : FieldValue.increment(Int64(1))], merge: true)
        callback()
    }
    
    func fetchReactions(completion: @escaping (_ : Reactions) -> Void){
        guard let reactionsCollection = reactionsCollection else { return }
        let userGroup = UserService.user.group
        let docRef = reactionsCollection.document("\(userGroup)-\(Date.today)")
        
        docRef.getDocument(as: Reactions.self) { result in
            switch result {
            case .success(let reactions):
                completion(reactions)
            case .failure(let error):
                print("Error decoding resctions: \(error)")
            }
        }
    }
}
