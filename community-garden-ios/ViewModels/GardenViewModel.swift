//
//  GardenViewModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 5/24/22.
//

import Foundation
import FirebaseAuth

class GardenViewModel: ObservableObject {
    
    enum GardenMode {
        case moving, planting
    }
    
    static var shared: GardenViewModel = GardenViewModel()
    let collections = Collections.shared
    let nc = NotificationCenter.default
    
    let gardenRepo = GardenRepository.shared
    let statsRepo = StatsSQLRepository.shared
    
    @Published var items: [GardenItem] = []
    @Published var dropItem = GardenElement.droplet
    @Published var gardenMode = GardenMode.moving
    @Published var sunMoon = "sun"
    @Published var showToast = false
    var toastMessage: ToastContent = ToastContent()
    
    var flowers: [GardenItem] = []
    var tree: GardenItem?
    
    init(){
        getUserItems()
//        nc.addObserver(self,
//                       selector: #selector(self.addTree),
//                       name: Notification.Name(NotificationType.CreateTree.rawValue),
//                       object: nil)
        
        setSunMoon()
    }
    
    @objc func getUserItems() -> Void {
        let collection = collections.getCollectionReference("gardenItems")
        
        
        guard let collection = collection else { return }
        guard let userID = getUserID() else { return }
        
        let query = collection.whereField("date", isEqualTo: Date.today)
            .whereField("userID", isEqualTo: userID)
        
        gardenRepo.getUserItems(query: query) { result in
            DispatchQueue.main.async {
                self.items = result
                
                let index = self.items.firstIndex{$0.type == GardenItemType.tree}
                
                if let index = index {
                    self.tree = self.items[index]
                }
                
            }
        }
    }
    
    func toggleGardenMode() {
        DispatchQueue.main.async {
            self.gardenMode = self.gardenMode == .moving ? .planting : .moving
        }
    }
    
    @objc func addTree(){
        let settings = UserService.shared.user.settings
        guard settings != nil else { return }
        let treeName = "\(settings!.treeColor)-\(addDash(settings!.tree))"
        let tree = GardenItem(userID: UserService.shared.user.id,
                              type: GardenItemType.tree,
                              name: treeName,
                              scale: 0.5,
                              group: UserService.shared.user.group,
                              gardenName: settings!.gardenName,
                              userName: UserService.shared.user.name)
        gardenRepo.addItem(item: tree)
        DispatchQueue.main.async {
            self.tree = tree
            self.items.append(tree)
        }
    }
    
    func setSunMoon() {
        let hour = Int(Date.hour)
        
        DispatchQueue.main.async {
            self.sunMoon = hour >= 18 || hour <= 7 ? "moon" : "sun"
        }
    }
    
    func addFlower(_ flower: GardenItem){
        gardenRepo.addItem(item: flower)
    }
    
    func updateTree(){
        if let item = tree {
            gardenRepo.udpateGardenItem(docName: item.documentName!, updates: item){}
        }
    }
    
    func decreaseNumDroplets(){
        statsRepo.updateNumDroplets(-1)
        UserViewModel.shared.getNumDroplets()
        SproutAnalytics.shared.useDroplet()
    }
    
    func decreaseNumSeeds(){
        statsRepo.updateNumSeeds(-1)
        UserViewModel.shared.getNumSeeds()
        SproutAnalytics.shared.useSeed()
    }
    
    func hasEnoughDroplets() -> Bool {
        if let stat = statsRepo.getNumDroplets() {
            return stat.value > 0
        }
        
        return false
    }
    
    func hasEnoughSeeds() -> Bool {
        if let stat = statsRepo.getNumSeeds() {
            return stat.value > 0
        }
        return false
    }
    
    func hasEnoughDropItem () -> Bool {
        let enoughDroplets = hasEnoughDroplets()
        let enoughtSeeds = hasEnoughSeeds()
        
        if dropItem == GardenElement.droplet {
            if enoughDroplets == false {
                
                toastMessage = ToastContent(image: "drop.fill",
                                            color: .blue,
                                            title: "Not Enough Droplets",
                                            subtitle: "You don't have any droplets.")
                
                DispatchQueue.main.async {
                    self.showToast = true
                }
            }
            return enoughDroplets;
        } else {
            if enoughtSeeds == false {
                
                toastMessage = ToastContent(image: "camera.macro",
                                            color: .pink,
                                            title: "Not Enough Seeds",
                                            subtitle: "You don't have any seeds.")
                
                DispatchQueue.main.async {
                    self.showToast = true
                }
            }
            return enoughtSeeds;
        }
    }
    
}

