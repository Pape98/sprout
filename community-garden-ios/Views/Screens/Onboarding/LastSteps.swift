//
//  LastSteps.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 21/06/2022.
//

import SwiftUI

struct LastSteps: View {
    
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    var userDefaults = UserDefaultsService.shared
    
    @State private var gardenName: String = ""
    @State private var reflectWeatherChanges = false
    @State private var showAlert = false

    
    var body: some View {
        VStack(){
            
            PickerTitle(header: "Final touches", subheader: "Your garden cannot wait to grow with you🍊")
            VStack (alignment: .leading) {
              
                VStack(alignment: .leading) {
                    Text("Enter your garden's name:")
                    TextField("", text: $gardenName )
                        .textFieldStyle(OvalTextFieldStyle())
                }.segment()
                Toggle("Reflect weather changes", isOn: $reflectWeatherChanges)
                    .tint(.appleGreen)
                    .segment()
            }
            .padding()
            
            Spacer()
            
            PickerButton(text: "Complete") {
                if(gardenName.count == 0){
                    showAlert = true
                    return
                }
                
                // Update view model to take user to home screen
                onboardingViewModel.isNewUser = OnboardingStatus.EXISITING_USER
                // Save data in user default
                userDefaults.save(value: OnboardingStatus.EXISITING_USER.rawValue, key: UserDefaultsKey.IS_NEW_USER)
                userDefaults.save(value: gardenName, key: UserDefaultsKey.GARDEN_NAME)
                userDefaults.save(value: reflectWeatherChanges, key: UserDefaultsKey.REFLECT_WEATHER_CHANGES)
            }
            .frame(maxWidth: 250)
            .padding()
         
        }
        .alert("Garden name cannot be empty 😊", isPresented: $showAlert){
            Button("OK", role: .cancel){}
        }
    }
}

struct LastSteps_Previews: PreviewProvider {
    static var previews: some View {
        LastSteps()
    }
}
