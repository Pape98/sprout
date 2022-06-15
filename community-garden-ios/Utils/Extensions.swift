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
    
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: self)
    }
    
    var day: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
    
    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        return dateFormatter.string(from: self)
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
    
    func convertToDateObject(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateObject = dateFormatter.date(from: self)
        
        if let dateObject = dateObject {
            return dateObject
        }
        
        return nil
    }
    
    func capitalizeFirstLetter() -> String {
            return prefix(1).capitalized + dropFirst()
        }

        mutating func capitalizeFirstLetter() {
            self = self.capitalizeFirstLetter()
        }
}

extension Color {
    static let pine = Color("pine")
    static let greenVogue = Color("green-vogue")
    static let seaGreen = Color("sea-green")
    static let oliveGreen = Color("olive-green")
    static let everglade = Color("everglade")
    static let appleGreen = Color("apple-green")
}

extension Text {
    func headerStyle() -> some View {
        self.font(.largeTitle)
            .foregroundColor(.seaGreen)
            .bold()
    }
    
    func bodyStyle() -> some View {
        self.foregroundColor(.seaGreen)
            .opacity(0.66)
    }
}

extension View {
    func screenBackground(_ image: String) -> some View {
        self.background{
            // Background Image
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
        }
    }
}

