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
        VStack() {
            Image(icon)
            Text(text)
                .font(.system(size: 15))
                .foregroundColor(.seaGreen)
        }.frame(maxWidth: .infinity, alignment: .trailing)
    }
}

struct IconButton_Previews: PreviewProvider {
    static var previews: some View {
        IconButton(icon:"garden-icon", text:"Your Garden")
    }
}
