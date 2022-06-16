//
//  PickerCardView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 6/6/22.
//

import SwiftUI

struct PickerCard: View {
    
    enum CircleType {
        case TREE
        case FLOWER
    }
    
    var option: String
    var circleType: CircleType
    
    var body: some View {
        HStack (spacing: 20) {
            
            if(circleType == CircleType.TREE){
                CircledTree(option: option, background: .oliveGreen)
            } else {
                CircledFlower(option: option, background: .oliveGreen)
            }
            
            Text(option.capitalizeFirstLetter())
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
        PickerCard(option: "oak", circleType: PickerCard.CircleType.TREE)
    }
}
