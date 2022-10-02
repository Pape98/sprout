//
//  Helpers.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/8/21.
//

import Foundation
import SwiftUI

struct ListBackgroundModifier: ViewModifier {

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .scrollContentBackground(.hidden)
        } else {
            content
        }
    }
}

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
    
    static var today: String {
        Date.now.getFormattedDate(format: "MM-dd-yyyy")
    }
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
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
    
    func convertToDictionary() -> [String: Any]? {
           if let data = data(using: .utf8) {
               return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
           }
           return nil
       }
}

extension Color {
    static let pine = Color("pine")
    static let greenVogue = Color("green-vogue")
    static let seaGreen = Color("sea-green")
    static let oliveGreen = Color("olive-green")
    static let everglade = Color("everglade")
    static let appleGreen = Color("apple-green")
    static let chalice = Color("chalice")
    static let teaGreen = Color("tea-green")
    static let leaf = Color("leaf")
    static let haze = Color("haze")
    static let ceramic = Color("ceramic")
    
    // Weather colors
    static let night = Color("night")
    static let evening = Color("evening")
    static let morning = Color("morning")
    static let day = Color("day")
    
    // Color options
    static let cosmos = Color("cosmos")
    static let sunglow = Color("sunglow")
    static let grenadier = Color("grenadier")
    static let hawks = Color("hawks")
    static let moss = Color("moss")
    static let tangerine = Color("tangerine")
    static let lavender = Color("lavender")
    static let mint = Color("mint")
    static let raspberry = Color("raspberry")
    static let porcelain = Color("porcelain")
    
}

extension Text {
    func headerStyle() -> some View {
        self.font(.largeTitle)
            .foregroundColor(.black)
            .bold()
            .font(.custom("Baloo", size: 25))
    }
    
    func bodyStyle() -> some View {
        self.foregroundColor(.black)
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
    
    func dataString(_ value: String) -> some View {
        environment(\.dataString, value)
    }
    
    func dataList(_ value: [Any]) -> some View {
        environment(\.dataList, value)
    }
    
    func weatherOverlay(showStats: Bool = true, opacity: Double = 1) -> some View {
        modifier(WeatherOverlay(showStats: showStats, opacity: opacity))
    }
    
    func segment() -> some View {
        modifier(Segment())
    }
    
    func acceptDrop(condition: Bool, action: @escaping (_ providers: [NSItemProvider]) -> Void) -> some View {
        modifier(Droppable(condition: condition, action: action))
    }
    
}

extension EnvironmentValues {
    
    var dataString: String {
        get { self[DataString.self] }
        set { self[DataString.self] = newValue }
    }
    
    var dataList: [Any] {
        get { self[DataList.self] }
        set { self[DataList.self] = newValue }
    }
}

extension AnyTransition {
    static var backslide: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading))}
}

extension Double {
    
    func truncate(to places: Int) -> Double {
        return Double(Int((pow(10, Double(places)) * self).rounded())) / pow(10, Double(places))
    }
    
}

extension Dictionary where Value : Hashable {

    func swapKeyValues() -> [Value : Key] {
        assert(Set(self.values).count == self.keys.count, "Values must be unique")
        var newDict = [Value : Key]()
        for (key, value) in self {
            newDict[value] = key
        }
        return newDict
    }
}


