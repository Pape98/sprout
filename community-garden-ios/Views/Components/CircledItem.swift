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
        
        //        Circle()
        //            .foregroundColor(color)
        //            .frame(maxWidth: 75, maxHeight: 75)
        //            .overlay(alignment: .bottom) {
        //                Image(optionName)
        //                    .resizable()
        //                    .scaledToFit()
        //            }
        
        Image(optionName)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: 75, maxHeight: 75)
            .background {
                GeometryReader { geometry in
                    HStack{
                        Circle()
                            .foregroundColor(color)
                            .frame(width: geometry.size.width * 0.85, height: geometry.size.height * 0.85)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
                }
            }
        
    }
}

struct CircledItem_Previews: PreviewProvider {
    static var previews: some View {
        CircledItem(optionName: "oak", color: .oliveGreen)
    }
}
