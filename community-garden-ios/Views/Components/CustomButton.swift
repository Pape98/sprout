//
//  CustomButton.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/19/21.
//

import SwiftUI

struct CustomButton: View {
    
    let title: String
    let backgroundColor: Color
    let fontColor: Color
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .frame(minWidth: 0, maxWidth: .infinity)
                .foregroundColor(fontColor)
                .padding()
                .background(backgroundColor)
                .cornerRadius(25)
                .contentShape(Rectangle())
        }
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(title: "Button Text",
                     backgroundColor: Color.gray,
                     fontColor: Color.white) {
        }
    }
}
