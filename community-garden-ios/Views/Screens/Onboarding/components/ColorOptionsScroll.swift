//
//  ColorOptionsScroll.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 17/06/2022.
//

import SwiftUI

struct ColorOptionsScroll: View {
    
    let data = (1...100).map { "Item \($0)" }
    
    let rows = [
        GridItem(.flexible()),
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyVGrid(columns: rows, spacing: 20) {
                HStack {
                    ForEach(Constants.colors, id: \.self) { color in
                        VStack {
                            Rectangle()
                                .fill(Color(color))
                                .frame(width:120, height:120)
                                .cornerRadius(10)
                                .padding()
                            Text(color)
                        }
                    }
                }
            }
            .padding()
        }
        
    }
}

struct ColorOptionsScroll_Previews: PreviewProvider {
    static var previews: some View {
        ColorOptionsScroll()
    }
}
