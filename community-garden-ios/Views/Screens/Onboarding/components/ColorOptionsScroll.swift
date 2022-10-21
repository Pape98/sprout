//
//  ColorOptionsScroll.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 17/06/2022.
//

import SwiftUI

struct ColorOptionsScroll: View {
    
    @Binding var selectedColor: String
    @Environment(\.dataString) var settingKey
    
    let rows = [
        GridItem(.flexible()),
    ]
    
    var colorOptions: [String] {
        var options = Constants.colors
        // Do not show moss color for flowers
        if(settingKey == FirestoreKey.FLOWER_COLOR.rawValue){
            options = options.filter{ $0 != "moss"}
        }
        return options
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyVGrid(columns: rows, spacing: 15) {
                HStack {
                    ForEach(colorOptions, id: \.self) { color in
                        
                        VStack {
                            Rectangle()
                                .fill(Color(color))
                                .frame(width:65, height:65)
                                .cornerRadius(10)
                                .padding()
                            Text(color.capitalizeFirstLetter())
                                .bodyStyle(size: 18)
                        }
                        .onTapGesture {
                            selectedColor = color;
                        }
                    }
                }
            }
        }
        
    }
}

struct ColorOptionsScroll_Previews: PreviewProvider {
    
    @State static var selectedColor = "moss"
    static var previews: some View {
        ColorOptionsScroll(selectedColor: $selectedColor)
    }
}
