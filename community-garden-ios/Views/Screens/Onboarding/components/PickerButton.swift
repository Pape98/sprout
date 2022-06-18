//
//  PickerNextButton.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 17/06/2022.
//

import SwiftUI

struct PickerButton: View {
    
    var text: String
    var selection: String
    var nextScreen: AnyView?
    var buttonColor: Color {
        text == "Next" ? .oliveGreen : .chalice
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        if nextScreen != nil {
            next
        } else {
            back
        }
    }
    
    var back: some View {
        
        Button(text) {
            presentationMode.wrappedValue.dismiss()
        } .buttonStyle(ActionButtonStyle(color: buttonColor))
    
    }
    
    var next: some View {
        NavigationLink(destination: nextScreen) {
            Text(text)
                .bold()
        }
        .disabled(selection == "")
        .opacity(selection == "" ? 0.5 : 1)
        .buttonStyle(ActionButtonStyle(color: buttonColor))
    }
}

struct PickerButton_Previews: PreviewProvider {
    static var previews: some View {
        PickerButton(text:"Next",selection: "selection", nextScreen: AnyView(Dashboard()))
    }
}
