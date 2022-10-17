//
//  BadgesViewModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 16/10/2022.
//

import Foundation

class BadgesViewModel: ObservableObject {
    static let shared = BadgesViewModel()
    @Published var showBadgesSheet = false
    
    init(){}
    
}
