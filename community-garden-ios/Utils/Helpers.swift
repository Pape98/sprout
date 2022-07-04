//
//  Helpers.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 6/7/22.
//

import Foundation
import CoreGraphics

func getFirstName(_ name: String) -> String {
    let delimiter = " "
    let tokens = name.components(separatedBy: delimiter)
    return tokens[0]
}

func getRandomCGFloat(_ start: CGFloat, _ end: CGFloat) -> CGFloat{
    return CGFloat.random(in: start...end+0.1)
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
