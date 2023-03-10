//
//  LastSteps.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 21/06/2022.
//

import SwiftUI

struct LastSteps: View {
    
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    @EnvironmentObject var onboardingRouter: OnboardingRouter
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    var userDefaults = UserDefaultsService.shared
    
    @State private var gardenName: String = ""
    @State private var reflectWeatherChanges = false
    @State private var showErrorAlert = false
    
    var body: some View {
        VStack(){
            
            PickerTitle(header: "Final touches", subheader: "Your garden cannot wait to grow with you🍊")
            VStack (alignment: .leading) {
                
                VStack(alignment: .leading) {
                    Text("Enter your garden's name:")
                        .bodyStyle(size: 18)
                    TextField("", text: $gardenName )
                        .textFieldStyle(OvalTextFieldStyle())
                }.segment()
            }
            .padding()
            
            Spacer()
            
            PickerButton(text: "Complete") {
                if(gardenName.count == 0){
                    showErrorAlert = true
                    return
                }
                
                onboardingRouter.saveSetting(key: FirestoreKey.GARDEN_NAME, value: gardenName)
                onboardingRouter.saveSetting(key: FirestoreKey.REFLECT_WEATHER_CHANGES, value: reflectWeatherChanges)
                
                onboardingViewModel.saveSettings(values: onboardingRouter.settings)
                onboardingViewModel.updateTokenAndStatus()
                
                onboardingRouter.setScreen(Screen.loader)
                
            }
            .frame(maxWidth: 250)
            .padding()
            
        }
        .alert("Garden name cannot be empty 😊", isPresented: $showErrorAlert){
            Button("OK", role: .cancel){}
        }
    }
}

struct LastSteps_Previews: PreviewProvider {
    static var previews: some View {
        LastSteps()
    }
}
