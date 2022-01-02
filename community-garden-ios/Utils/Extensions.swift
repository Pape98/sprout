//
//  Helpers.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/8/21.
//

import Foundation
import SwiftUI

extension Date {
    func getFormattedDate(format: String) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format
        return dateFormat.string(from: self)
    }
}

extension String {
    func convertToDateObject() -> Date? {
        let dateFormatter = DateFormatter()
        let dateObject = dateFormatter.date(from: self)
        
        if let dateObject = dateObject {
            return dateObject
        }
        
        return nil
    }
}
