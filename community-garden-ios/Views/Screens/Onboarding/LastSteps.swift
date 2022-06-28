//
//  LastSteps.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 21/06/2022.
//

import SwiftUI

struct LastSteps: View {
    
    var userDefaults = UserDefaultsService.shared
    
    @State private var gardenName: String = ""
    @State private var reflectWeatherChanges = false

    
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
            
            BackNextButtons(){}
         
        }
    }
}

struct LastSteps_Previews: PreviewProvider {
    static var previews: some View {
        LastSteps()
    }
}
