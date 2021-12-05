//
//  Health.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/4/21.
//

import Foundation

class Step: Identifiable, CustomStringConvertible {
    
    let id: UUID = UUID()
    let count: Int
    let date: String
    
    var description: String {
        return "Step: (Date: \(date), Count: \(count))"
    }
    
    init(_ count: Int, _ date: String) {
        self.count = count
        self.date = date
    }
}
