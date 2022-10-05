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
        text == "Back" ? .chalice : .appleGreen
    }
    
    @EnvironmentObject var onboardingRouter: OnboardingRouter
    @Environment(\.presentationMode) var presentationMode
    
    public init(text: String, action: (() -> Void)? = nil){
        self.text = text;
        self.action = action
    }
    
    var body: some View {
        Button(text){
            let transition: AnyTransition = text == "Next" || text == "Done" ? .backslide : .slide
            
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
    var isError: Bool = false
    
    var action: (() -> Void)? = nil
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            PickerButton(text: "Back"){
                onboardingRouter.navigateBack()
            }
            
            PickerButton(text:"Next"){
                
                if let action = action {
                    action()
                }
                
                guard isError == false else { return }
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
