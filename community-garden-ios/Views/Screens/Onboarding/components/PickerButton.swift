//
//  PickerNextButton.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 17/06/2022.
//

import SwiftUI

struct PickerButton: View {
    
    var text: String
    var action: (() -> Void)? = nil
    
    var buttonColor: Color {
        text == "Next" ? .appleGreen : .chalice
    }
    
    @EnvironmentObject var onboardingRouter: OnboardingRouter
    @Environment(\.presentationMode) var presentationMode
    
    public init(text: String, action: (() -> Void)? = nil){
        self.text = text;
        self.action = action
    }
    
    var body: some View {
        Button(text){
            let transition: AnyTransition = text == "Next" ? .backslide : .slide
            
            onboardingRouter.setTransition(transition)
            
            if let action = action {
                withAnimation {
                    action()
                }
            }
        }
        .buttonStyle(ActionButtonStyle(color: buttonColor))
    }
}

struct BackNextButtons: View {
    
    @EnvironmentObject var onboardingRouter: OnboardingRouter
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            PickerButton(text: "Back"){
                onboardingRouter.navigateBack()
            }
            
            PickerButton(text:"Next"){
                onboardingRouter.navigateNext()
            }
            
        }.padding()
    }
}

struct PickerButton_Previews: PreviewProvider {
    static var previews: some View {
        PickerButton(text:"Next")
            .environmentObject(OnboardingRouter())
    }
}
