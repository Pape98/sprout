//
//  Settings.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 04/07/2022.
//

import SwiftUI


struct Settings: View {
    
    @State private var reflectWeatherChanges = false
    var treeTypes = Constants.trees
    var flowerTypes = Constants.flowers
    var treeColors = Constants.colors
    var flowerColors = Constants.colors.filter { $0 != "moss"}
    
    var body: some View {
        NavigationView {
            List {
                
                Section("Garden"){
                    Text("Change Garden Name")
                    Toggle("Reflect weather changes", isOn: $reflectWeatherChanges)
                        .tint(.appleGreen)
                }
                
                Section("Types & Colors"){
                    SettingButton(label: "Tree Type",
                                  image: "moss-tickle-beech",
                                  prefix: "moss",
                                  data: treeTypes,
                                  mode: SettingsMode.treeType)
                    
                    SettingButton(label: "Flower Type",
                                  image: "flowers/grenadier-joyful-clover",
                                  prefix: "flowers/cosmos",
                                  data: flowerTypes,
                                  mode: SettingsMode.flowerType)
                        
                    
                    SettingButton(label: "Tree Color",
                                  image: "sunglow-spiky-maple",
                                  data: treeColors,
                                  mode: SettingsMode.treeColor)
                    
                    SettingButton(label: "Flower color",
                                  image: "petals/tangerine-savage-morel",
                                  data: flowerColors,
                                  mode: SettingsMode.flowerColor)
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
