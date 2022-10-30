//
//  SproutsWidgets.swift
//  PersonalStatusWidgetExtension
//
//  Created by Pape Sow Traoré on 30/10/2022.
//

import SwiftUI
import WidgetKit
import Firebase

@main
struct SproutsWidgets: WidgetBundle {
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Widget {
        PersonalStatusWidget()
        CommunityWidget()
    }
}
