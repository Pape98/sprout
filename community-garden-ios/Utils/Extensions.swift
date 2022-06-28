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
    static let lavendar = Color("lavendar")
    static let mint = Color("mint")
    static let raspberry = Color("raspberry")
    static let porcelain = Color("porcelain")
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
    
    func userDefaultsKey(_ value: UserDefaultsKey) -> some View {
        environment(\.userDefaultsKey, value)
    }
    
    func weatherOverlay() -> some View {
        modifier(WeatherOverlay())
    }
    
    func segment() -> some View {
        modifier(Segment())
    }
    
    func acceptDrop(condition: Bool, action: @escaping (_ providers: [NSItemProvider]) -> Void) -> some View {
        modifier(Droppable(condition: condition, action: action))
    }
}

extension EnvironmentValues {
    var userDefaultsKey: UserDefaultsKey {
        get { self[SettingsKey.self] }
        set { self[SettingsKey.self] = newValue }
    }
}

extension AnyTransition {
    static var backslide: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading))}
}

