//
//  CommunityViewModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 18/09/2022.
//

import Foundation

class CommunityViewModel: ObservableObject {
    static let shared = CommunityViewModel()
    
    let gardenRepository = GardenRepository.shared
    let collections = Collections.shared
    
    @Published var trees: [GardenItem] = []
    
    init(){
        fetchTrees()
    }
    
    func fetchTrees(){
        let userGroup = UserService.user.group
        let collection = self.collections.getCollectionReference(CollectionName.gardenItems.rawValue)
        guard let collection = collection else { return }
        let query = collection.whereField("date", isEqualTo: Date.today)
            .whereField("group", isEqualTo: userGroup)
            .whereField("type", isEqualTo: GardenItemType.tree.rawValue)
        
        gardenRepository.getUserItems(query: query) { trees in
            DispatchQueue.main.async {
                self.trees = trees
            }
        }
    }
}
