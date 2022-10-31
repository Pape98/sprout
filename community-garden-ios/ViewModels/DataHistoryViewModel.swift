//
//  DataHistoryViewModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 10/31/22.
//

import Foundation

class DataHistoryViewModel: ObservableObject {
    static let shared = DataHistoryViewModel()
    let gardenRepo: GardenRepository = GardenRepository.shared
    let collections = Collections.shared
    
    @Published var historyItems: [GardenItem] = []
    
    func getUserItemsByDate(date: String) -> Void {
        let collection = collections.getCollectionReference("gardenItems")
        
        
        guard let collection = collection else { return }
        guard let userID = getUserID() else { return }
                
        let query = collection.whereField("date", isEqualTo:date)
                              .whereField("userID", isEqualTo: userID)
                
        gardenRepo.getUserItems(query: query) { result in
            DispatchQueue.main.async {
                self.historyItems = result
                Debug.log.debug(result)
            }
        }
    }
    
}
