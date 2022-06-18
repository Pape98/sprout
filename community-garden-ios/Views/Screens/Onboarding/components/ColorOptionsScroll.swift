//
//  ColorOptionsScroll.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 17/06/2022.
//

import SwiftUI

struct ColorOptionsScroll: View {
    
    @Binding var selectedColor: String
    
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
                                .frame(width:75, height:75)
                                .cornerRadius(10)
                                .padding()
                            Text(color.capitalizeFirstLetter())
                        }
                        .onTapGesture {
                            selectedColor = color;
                        }
                    }
                }
            }
            .padding()
        }
        
    }
}

struct ColorOptionsScroll_Previews: PreviewProvider {
    
    @State static var selectedColor = "moss"
    static var previews: some View {
        ColorOptionsScroll(selectedColor: $selectedColor)
    }
}
