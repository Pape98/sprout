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
            Image(option)
                .resizable()
                .scaledToFit()
                .frame(width: size-15, height: size-15)
        }.frame(width: size, height: size)
    }
}

struct CircledFlower_Previews: PreviewProvider {
    static var previews: some View {
        CircledFlower(option: "poppy", background: .oliveGreen, size: 200)
    }
}
