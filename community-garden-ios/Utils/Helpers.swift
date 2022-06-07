//
//  Helpers.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 6/7/22.
//

import Foundation

func getFirstName(_ name: String) -> String {
    let delimiter = " "
    let tokens = name.components(separatedBy: delimiter)
    return tokens[0]
}
