//
//  Settings.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 04/07/2022.
//

import SwiftUI

struct Settings: View {
    
    @State private var reflectWeatherChanges = false
    
    var body: some View {
        NavigationView {
            List {
                
                Section("Garden"){
                    Text("Change Garden Name")
                    Toggle("Reflect weather changes", isOn: $reflectWeatherChanges)
                        .tint(.appleGreen)
                }
                
                Section("Types & Colors"){
                    SettingButton(label: "Tree Type", image: "moss-tickle-beech")
                    SettingButton(label: "Flower Type", image: "flowers/grenadier-joyful-clover")
                    SettingButton(label: "Tree Color", image: "sunglow-spiky-maple")
                    SettingButton(label: "Flower color", image: "petals/tangerine-savage-morel")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
        .foregroundColor(.black)
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
