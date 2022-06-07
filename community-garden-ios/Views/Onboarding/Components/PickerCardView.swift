//
//  PickerCardView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 6/6/22.
//

import SwiftUI

struct PickerCardGraphic: View {
    var optionName: String
    
    var body: some View {
        
        Circle()
            .foregroundColor(.oliveGreen)
            .frame(maxWidth: 75, maxHeight: 75)
            .overlay(alignment: .bottom) {
                Image(optionName)
                    .resizable()
                    .scaledToFit()
            }
        
    }
}

struct PickerCardView: View {
    
    var optionName: String
    
    var body: some View {
        HStack (spacing: 20) {
            PickerCardGraphic(optionName: optionName)
            Text(optionName.capitalizeFirstLetter())
                .font(.title2)
                .bold()
                .foregroundColor(.everglade)
            Spacer()
        }
        .padding(15)
        .background(Color.white)
        .cornerRadius(10)
    }
    
}

struct PickerCardView_Previews: PreviewProvider {
    static var previews: some View {
        PickerCardView(optionName: "oak")
    }
}
