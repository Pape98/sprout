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
struct SproutsWidgets {

    init(){
        addKeyChainAccessGroup()
    }
    
    func addKeyChainAccessGroup(){
        do {
            try Auth.auth().useUserAccessGroup("group.empower.lab.community-garden")
        } catch let error as NSError {
            print("Widget Error changing user access group: %@", (error as NSError).userInfo)
        }
    }
    
    static func main() {
        PersonalStatusWidget.main()
    }
    
}
