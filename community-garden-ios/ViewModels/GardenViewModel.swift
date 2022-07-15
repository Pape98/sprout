//
//  GardenViewModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 5/24/22.
//

import Foundation
import FirebaseAuth

class GardenViewModel: ObservableObject {
    
    static var shared: GardenViewModel = GardenViewModel()
    let gardenRepo = GardenRepository.shared
    let userDefaults = UserDefaultsService.shared
    let collections = Collections.shared
    
    @Published var items: [GardenItem] = []
    var flowers: [GardenItem] = []
    var dropItem = GardenElement.droplet
    var tree: GardenItem?
    
    var userDefaultTree: String {
        let color = userDefaults.get(key: UserDefaultsKey.TREE_COLOR) ?? "moss"
        let tree = userDefaults.get(key: UserDefaultsKey.TREE) ?? "spiky-maple"
        return "\(color)-\(tree)"
    }
    
    var userDefaultFlower: String {
        let color = userDefaults.get(key: UserDefaultsKey.FLOWER_COLOR) ?? ""
        let tree = userDefaults.get(key: UserDefaultsKey.FLOWER_COLOR) ?? "abyss-sage"
        return "\(color)-\(tree)"
    }
    
    init(){
        getUserItems()
//        deleteFlowers()
//        resetTree()
    }
    
    func getUserItems() -> Void {
        let collection = collections.getCollectionReference("gardenItems")
        
        guard let collection = collection else { return }
        guard let userID = getUserID() else { return }
        
        let query = collection.whereField("date", isEqualTo: Date.today)
                              .whereField("userID", isEqualTo: userID)
              
        gardenRepo.getUserItems(query: query) { result in
            DispatchQueue.main.async {
                self.items = result
                // Get single tree
                if let i = result.firstIndex(where: { $0.type == GardenItemType.tree }) {
                    self.tree = result[i]
                }
            }
        }
    }
    
    func addTree(){
        let tree = GardenItem(userID: UserService.user.id, type: GardenItemType.tree, name: userDefaultTree)
        gardenRepo.addItem(item: tree)
    }
    
    func addFlower(_ flower: GardenItem){
        flowers.append(flower)
    }
    
    func saveItems(){
        saveFlowers()
        saveTreeScale()
    }
    
    func saveFlowers(){
        for flower in flowers {
            gardenRepo.addItem(item: flower)
            items.append(flower)
        }
        flowers = []
    }
    
    func saveTreeScale(){
        if let item = tree {
            gardenRepo.udpateGardenItem(docName: "tree", updates: item)
        }
    }
    
    func resetTree(){
        let tree = GardenItem(userID: UserService.user.id, type: GardenItemType.tree, name: userDefaultTree, scale: 0.2)
        gardenRepo.udpateGardenItem(docName: "tree", updates: tree)
    }
    
    func deleteFlowers(){
        gardenRepo.resetFlowers()
        flowers = []
    }
}
