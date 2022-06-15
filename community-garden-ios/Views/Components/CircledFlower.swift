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
            Image(option)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
        }.frame(width: 75, height: 75)
    }
}

struct CircledFlower_Previews: PreviewProvider {
    static var previews: some View {
        CircledFlower(option: "poppy", background: .oliveGreen)
    }
}
