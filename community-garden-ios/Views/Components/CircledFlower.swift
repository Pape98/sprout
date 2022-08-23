//
//  CircledFlower.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 15/06/2022.
//

import SwiftUI

struct CircledFlower: View {
    
    var option: String
    var background: Color
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(background)
            Image("petals/\(option)")
                .resizable()
                .scaledToFit()
                .padding(7)
             
        }
    }
}

struct CircledFlower_Previews: PreviewProvider {
    static var previews: some View {
        CircledFlower(option: "grenadier-abyss-sage", background: .oliveGreen)
    }
}
