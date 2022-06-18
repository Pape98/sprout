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
                CircledTree(option: "moss-\(option)", background: .oliveGreen)
            } else {
                CircledFlower(option: option, background: .oliveGreen)
            }
            
            Text(formatItemName(option))
                .font(.title2)
                .bold()
                .foregroundColor(.everglade)
            Spacer()
        }
        .padding(15)
        .background(Color.white)
        .cornerRadius(10)
        .frame(height: 100)
    }
    
}

struct PickerCardView_Previews: PreviewProvider {
    static var previews: some View {
        PickerCard(option: "spiky-maple", circleType: PickerCard.CircleType.TREE)
    }
}
