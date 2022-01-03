//
//  Health.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/4/21.
//

import Foundation

class Data: Identifiable {
    
    var id: String = UUID().uuidString
    var date: Date = Date.now
    
}

class Step: Data, Equatable, Hashable, CustomStringConvertible {
    
    var count: Int = 0
    
    var description: String {
        let formattedDate = super.date.getFormattedDate(format: "MM-dd-YYYY")
        return "Step => id: \(super.id) date:\(formattedDate as String?) count:\(count)"
    }
    
    override init() {
        super.init()
    }
    
    init(date: Date, count: Int){
        super.init()
        self.count = count
        super.date = date
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(super.date)
        hasher.combine(count)
    }
    
    static func == (lhs: Step, rhs: Step) -> Bool {
        return lhs.date == rhs.date && lhs.count == rhs.count
    }
}
