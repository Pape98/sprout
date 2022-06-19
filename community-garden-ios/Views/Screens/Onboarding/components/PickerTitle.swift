//
//  PickerTitle.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 18/06/2022.
//

import SwiftUI

struct PickerTitle: View {
    
    var header: String
    var subheader: String? = "Subheader of main header"
    
    var body: some View {
        VStack {
            Text(header)
                .headerStyle()
                .lineLimit(1)
            if let subheader = subheader {
                Text(subheader)
                    .bodyStyle()
            }
            
        }.padding()
    }
}

struct PickerTitle_Previews: PreviewProvider {
    static var previews: some View {
        PickerTitle(header: "This is a nice header")
    }
}
