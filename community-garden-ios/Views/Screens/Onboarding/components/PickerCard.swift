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
    
    var borderWidth: CGFloat {
        isSelected ? 8 : 0
    }
    
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                
                
                Group {
                    RoundedRectangle(cornerRadius: 10)
                        .inset(by: 1)
                        .stroke(Color.appleGreen, lineWidth: borderWidth)
                    
                }.background(Color.white)
                    .cornerRadius(10)
                    .opacity(0.5)
                
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
