//
//  CustomButton.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/19/21.
//

import SwiftUI

struct CustomButton: View {
    
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .frame(minWidth: 0, maxWidth: .infinity)
                .foregroundColor(.white)
                .padding()
                .background(.secondary)
                .cornerRadius(25)
                .contentShape(Rectangle())
        }
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(title: "Button Text") {
            print("Custom Button")
        }
    }
}
