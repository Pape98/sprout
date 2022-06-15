//
//  PickerCardView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 6/6/22.
//

import SwiftUI

struct PickerCard: View {
    
    var optionName: String
    
    var body: some View {
        HStack (spacing: 20) {
            CircledTree(optionName: optionName, color: .oliveGreen)
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
        PickerCard(optionName: "oak")
    }
}
