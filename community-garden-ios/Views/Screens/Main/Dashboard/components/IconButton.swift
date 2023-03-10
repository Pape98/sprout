//
//  IconButton.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 6/7/22.
//

import SwiftUI

struct IconButton: View {
    var icon: String
    var text: String
    
    var body: some View {
        VStack(spacing: 2) {
            Image(icon)
              
            Text(text)
                .bold()
                .font(.custom(Constants.mainFont, size: 25))
     
        }.frame(maxWidth: .infinity, alignment: .center)
    }
}

struct IconButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 0) {
            IconButton(icon:"garden-icon", text:"Your Garden")
          
            IconButton(icon:"seed-icon", text:"Your Garden")
      
            IconButton(icon:"droplet-icon", text:"Your Garden")
      
        }
    }
}
