//
//  Helpers.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 6/7/22.
//

import Foundation
import SwiftUI
import CoreGraphics
import FirebaseAuth

func getFirstName(_ name: String) -> String {
    let delimiter = " "
    let tokens = name.components(separatedBy: delimiter)
    return tokens[0]
}

func getRandomCGFloat(_ start: CGFloat, _ end: CGFloat) -> CGFloat{
    return CGFloat.random(in: start...end+0.1)
}

func getRandomNumber(_ start: Int, _ end: Int) -> Int {
    return Int.random(in: start...end+1)
}

func formatItemName(_ name: String) -> String{
    let tokens = name.components(separatedBy: "-")
    let capitalizedTokens = tokens.map { $0.capitalized}
    return capitalizedTokens.joined(separator: " ")
}

func splitString(str: String) -> String {
    var res = ""
    for char in str {
        
        if char.isUppercase && res.isEmpty == false {
            res += " "
        }
        res += "\(char)"
    }
    return res
}

func getWeatherInfo() -> [String: String]{
    let date = Date()
    let dateComponents = Calendar.current.dateComponents([.hour], from: date)
    let hour = dateComponents.hour!
    //
    //    if hour >= 0 && hour <= 5 { // night
    //        return ["image": "night-bg", "color": "night"]
    //    } else if hour >= 6 && hour <= 9 { // morning
    //        return ["image": "morning-bg", "color": "morning"]
    //    } else if hour >= 10 && hour <= 20 { // day
    //        return ["image": "day-bg", "color": "day"]
    //    } else { // evening
    //        return ["image": "evening-bg", "color": "evening"]
    //    }
    
    return ["image": "day-bg", "color": "day"]
}

func getUserID() -> String? {
    return Auth.auth().currentUser?.uid
}

func addDash(_ s: String) -> String {
    return s.replacingOccurrences(of: " ", with: "-")
}

func dataEncoder<T: Encodable>(data: T) -> Data? {
    do {
        // Create JSON Encoder
        let encoder = JSONEncoder()
        
        // Encode Data
        let data = try encoder.encode(data)
        
        return data
        
    } catch {
        print("Unable to Encode Note (\(error))")
    }
    
    return nil
}

func dataArrayDecoder<T: Decodable>(data: Data, type: T.Type) -> [T] {
    do {
        // Create JSON Decoder
        let decoder = JSONDecoder()
        
        // Decode Data
        let decodedData = try decoder.decode([T].self, from: data)
        
        return decodedData
        
    } catch {
        print("Unable to Decode Note (\(error))")
    }
    
    return []
}

func getSampleUserGarden() -> UserGarden {
    let settings = UserSettings(tree: "spiky-maple", treeColor: "cosmos")
    let user = User(id: "pape", name: "Pape Sow", email: "", group: 0, settings: settings)
    let gardenItems: [GardenItem] = []
    let garden = UserGarden(user: user, items: gardenItems)
    
    return garden
}
