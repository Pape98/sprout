//
//  Health.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/4/21.
//

import Foundation

class Step: Identifiable {
    
    let id:UUID
    let count: Int
    let date: Date
    
    init(_ id:UUID = UUID(),_ count:Int,_ date:Date) {
        self.id = id
        self.count = count
        self.date = date
    }
}
