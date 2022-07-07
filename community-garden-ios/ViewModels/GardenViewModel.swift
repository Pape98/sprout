//
//  GardenViewModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 5/24/22.
//

import Foundation

class GardenViewModel: ObservableObject {
    
    static var shared: GardenViewModel = GardenViewModel()
    let userRepository = UserRepository.shared
    let TREE_SCALE_FACTOR = 0.03

    func handleDropletRelease(){
        
    }
}
