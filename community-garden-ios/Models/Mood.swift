//
//  Mood.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/19/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Mood: Codable, Identifiable {
    
    @DocumentID var id: String?
    var text: String = ""
    var date: Date?
    var userId: String = ""
}
