//
//  Mood.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/19/21.
//

import Foundation

struct Mood: Identifiable {
    
    var id: String = UUID().uuidString
    var text: String = ""
    var date: String = ""
    var userId: String = ""
    var timestamp: String = ""
}
