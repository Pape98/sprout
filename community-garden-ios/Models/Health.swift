//
//  Health.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/4/21.
//

import Foundation

class Step: Identifiable, CustomStringConvertible {
    
    var id: UUID?
    var count: Int
    var date: String
    
    var description: String {
        return "Step: (Date: \(date), Count: \(count))"
    }
    
    init(_ count: Int, _ date: String) {
        self.count = count
        self.date = date
    }
}
