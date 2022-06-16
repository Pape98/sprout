//
//  CircledTree.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 6/6/22.
//

import SwiftUI

struct CircledTree: View {
    var option: String
    var background: Color
    var body: some View {

        Image(option)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: 75, maxHeight: 75)
            .background {
                GeometryReader { geometry in
                    HStack{
                        Circle()
                            .foregroundColor(background)
                            .frame(width: geometry.size.width * 0.85, height: geometry.size.height * 0.85)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
                }
            }
        
    }
}

struct CircledTree_Previews: PreviewProvider {
    static var previews: some View {
        CircledTree(option: "oak", background: .oliveGreen)
    }
}
