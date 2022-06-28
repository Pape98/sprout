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
    var size: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(background)
            Image("petals/\(option)")
                .resizable()
                .scaledToFit()
                .frame(width: size-15, height: size-15)
                .padding(30)
        }
         .frame(width: size, height: size)
         .padding()
    }
}

struct CircledFlower_Previews: PreviewProvider {
    static var previews: some View {
        CircledFlower(option: "grenadier-abyss-sage", background: .oliveGreen, size: 200)
    }
}
