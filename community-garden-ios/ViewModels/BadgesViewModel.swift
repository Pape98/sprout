//
//  BadgesViewModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 16/10/2022.
//

import Foundation

class BadgesViewModel: ObservableObject {
    static let shared = BadgesViewModel()
    let groupRepository = GroupRepository.shared
    
    init(){}
    
}
