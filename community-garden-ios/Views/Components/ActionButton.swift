//
//  ActionButton.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/19/21.
//

import SwiftUI

struct ActionButton: View {
    
    let title: String
    var backgroundColor: Color = Color.gray
    var fontColor: Color = Color.black
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .bold()
                .frame(minWidth: 0, maxWidth: .infinity)
                .foregroundColor(fontColor)
                .padding()
                .background(backgroundColor)
                .cornerRadius(100)
                .contentShape(Rectangle())
            
        }
    }
}

struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        ActionButton(title: "Button Text",
                     action:  {})
        
    }
}
