//
//  ButtonStyling.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 6/6/22.
//

import Foundation
import SwiftUI

struct ActionButtonStyle: ButtonStyle {
    
    var color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .foregroundColor(Color.white)
            .padding()
            .background(color)
            .cornerRadius(100)
            .contentShape(Rectangle())
            .font(.custom(Constants.mainFont, size: 20))
        
    }
}

struct OvalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(Color.haze)
            .cornerRadius(10)
            .foregroundColor(.gray)
    }
}

