//
//  CustomButton.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/19/21.
//

import SwiftUI

struct CustomButton: View {
    
    let title: String
    var backgroundColor: Color = Color.gray
    var fontColor: Color = Color.black
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
                .cornerRadius(20)
                .contentShape(Rectangle())
        }
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(title: "Button Text",
                     action:  {})
        
    }
}
