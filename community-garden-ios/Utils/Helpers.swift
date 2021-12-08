//
//  Helpers.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/8/21.
//

import Foundation



struct Helpers {
    
}

extension Date {
    func getFormattedDate(format: String) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format
        return dateFormat.string(from: self)
    }
}
