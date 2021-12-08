//
//  Health.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/4/21.
//

import Foundation

class Data: Identifiable, Equatable, Hashable {
    
    var id: String = UUID().uuidString
    var date: String = ""
    
    static func == (lhs: Data, rhs: Data) -> Bool {
        return lhs.date == rhs.date
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(date)
    }
}

class Step: Data {
    
    var count: Int = 0
    
    init(date: String, count: Int){
        super.init()
        self.count = count
        super.date = date
    }
}
