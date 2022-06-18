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
    var isSelected: Bool
    
    let size: CGFloat = 50
    
    var selection: String {
        if(circleType == CircleType.TREE){
            return "moss-\(option)"
        } else {
            return option
        }
    }
    
    var background: Color {
        isSelected ? .teaGreen : .white
    }
    
    var opacity: CGFloat {
        isSelected ? 0.9 : 0.6
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                Rectangle()
                    .fill(background)
                    .opacity(opacity)
                
                VStack (spacing: 20) {
                    
                    Image(selection)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.5, height: geometry.size.width * 0.5)
                    
                    Text(formatItemName(option))
                        .font(.system(size: geometry.size.width * 0.1))
                        .foregroundColor(.everglade)
                        .bold()
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
}

struct PickerCardView_Previews: PreviewProvider {
    static var previews: some View {
        PickerCard(option: "spiky-maple",
                   circleType: PickerCard.CircleType.TREE,
                   isSelected: false)
    }
}
