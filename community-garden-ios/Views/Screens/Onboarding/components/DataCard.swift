//
//  DataCard.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 20/06/2022.
//

import SwiftUI

struct DataCard: View {
    
    var data: String
    var isSelected: Bool
    var metadata: [String]? {
        DataOptions.icons[data]
    }
    
    var opacity: CGFloat {
        isSelected ? 1 : 0.5
    }
    
    var borderWith: CGFloat {
        isSelected ? 8 : 0
    }
    
    var body: some View {
        ZStack {
            Group {
                RoundedRectangle(cornerRadius: 10)
                    .inset(by: 1)
                    .stroke(Color.appleGreen, lineWidth: borderWith)
                
            }.background(Color.white)
                .cornerRadius(10)
                .opacity(0.5)
            
            HStack {
                
                VStack(alignment: .leading, spacing:10) {
                    Text(data)
                        .bold()
                        .font(.title3)
                        .foregroundColor(.seaGreen)
                    if let metadata = metadata {
                        Text(metadata[1])
                            .foregroundColor(.everglade)
                    }
                    
                }.padding()
                
                Spacer()
                
            }
        }
        .frame(maxHeight: 90)
    }
}

struct DataCard_Previews: PreviewProvider {
    static var previews: some View {
        DataCard(data: "Sleep", isSelected: false)
    }
}
