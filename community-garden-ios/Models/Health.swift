//
//  Health.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/4/21.
//

import Foundation
import FirebaseFirestoreSwift

class Step: Identifiable, Equatable, Hashable, CustomStringConvertible, Codable {
    
    @DocumentID var id: String? = UUID().uuidString
    var count: Int = 0
    var date: Date
    
    var description: String {
        let formattedDate = date.getFormattedDate(format: "MM-dd-YYYY")
        return "Step => id: \(id) date:\(formattedDate as String?) count:\(count)"
    }
    
    init(date: Date, count: Int){
        self.count = count
        self.date = date
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(date)
        hasher.combine(count)
    }
    
    static func == (lhs: Step, rhs: Step) -> Bool {
        return lhs.date == rhs.date && lhs.count == rhs.count
    }
}
