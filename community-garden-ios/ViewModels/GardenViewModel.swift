//
//  GardenViewModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 5/24/22.
//

import Foundation

class GardenViewModel: ObservableObject {
    
    static var shared: GardenViewModel = GardenViewModel()
    let gardenRepo = GardenRepository.shared
    let userDefaults = UserDefaultsService.shared
    
    @Published var items: [GardenItem] = []
    var flowers: [GardenItem] = []
    var dropItem = GardenElement.droplet
    
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
        getItems()
    }
    
    func getItems() -> Void {
        gardenRepo.getItems { result in
            DispatchQueue.main.async {
                self.items = result
            }
        }
    }
    
    func addTree(){
        let tree = GardenItem(type: GardenItemType.tree, name: userDefaultTree)
        gardenRepo.addItem(item: tree)
    }
    
    func addFlower(_ flower: GardenItem){
        flowers.append(flower)
    }
    
    func saveFlowers(){
        for flower in flowers {
            gardenRepo.addItem(item: flower)
            items.append(flower)
        }
        flowers = []
    }
    
    func getTree(){
        
    }
}
