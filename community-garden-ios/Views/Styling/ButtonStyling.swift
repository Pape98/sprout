//
//  ButtonStyling.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 6/6/22.
//

import Foundation
import SwiftUI

struct ActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .foregroundColor(Color.white)
            .padding()
            .background(Color.appleGreen)
            .cornerRadius(100)
            .contentShape(Rectangle())
        
    }
}
