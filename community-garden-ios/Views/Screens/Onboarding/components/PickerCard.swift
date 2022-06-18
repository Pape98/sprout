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
    let size: CGFloat = 150.0
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack (spacing: 20) {
                
                if(circleType == CircleType.TREE){
                    CircledTree(
                        option: "moss-\(option)",
                        background: .oliveGreen,
                        size: geometry.size.width * 0.5
                    )
                } else {
                    CircledFlower(option: option,
                                  background: .oliveGreen,
                                  size: 50
                    )
                }
                
                Text(formatItemName(option))
                    .font(.system(size: geometry.size.width * 0.1))
                    .foregroundColor(.everglade)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
        }
    }
    
}

struct PickerCardView_Previews: PreviewProvider {
    static var previews: some View {
        PickerCard(option: "spiky-maple", circleType: PickerCard.CircleType.TREE)
    }
}
