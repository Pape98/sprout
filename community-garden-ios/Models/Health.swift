//
//  Health.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/4/21.
//

import Foundation

class Data: Identifiable {
    
    var id: String? = UUID().uuidString
    var date: String = ""
}

class Step: Data, Equatable, Hashable, CustomStringConvertible {
    
    var count: Int = 0
    
    var description: String {
        return "Step => date:\(super.date) count:\(count)"
    }
    
    override init() {
        super.init()
    }
    
    init(date: String, count: Int){
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
