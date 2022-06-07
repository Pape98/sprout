//
//  CircledItem.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 6/6/22.
//

import SwiftUI

struct CircledItem: View {
    var optionName: String
    var color: Color
    var body: some View {
        
        Circle()
            .foregroundColor(color)
            .frame(maxWidth: 75, maxHeight: 75)
            .overlay(alignment: .bottom) {
                Image(optionName)
                    .resizable()
                    .scaledToFit()
            }
        
    }
}

struct CircledItem_Previews: PreviewProvider {
    static var previews: some View {
        CircledItem(optionName: "oak", color: .oliveGreen)
    }
}
