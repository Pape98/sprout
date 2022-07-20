//
//  Settings.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 04/07/2022.
//

import SwiftUI


struct Settings: View {
    
    @StateObject var settingsViewModel: SettingsViewModel = SettingsViewModel()
    
    @State private var reflectWeatherChanges = false
    @State var settings = UserService.user.settings!

    var treeTypes = Constants.trees
    var flowerTypes = Constants.flowers
    var treeColors = Constants.colors
    var flowerColors = Constants.colors.filter { $0 != "moss"}
    
    var body: some View {
        NavigationView {
            List {
                
                Section("Garden"){
                    
                    NavigationLink {
                        NameChanging()
                    } label : {
                        Text("Garden Name")
                    }
                    
                    Toggle("Reflect weather changes", isOn: $reflectWeatherChanges)
                        .tint(.appleGreen)
                        .onChange(of: reflectWeatherChanges) { newValue in
                            settings.reflectWeatherChanges = newValue
                            settingsViewModel.updateSettings(settingKey: FirestoreKey.REFLECT_WEATHER_CHANGES, value: newValue)
                        }
                }
                
                Section("Types & Colors"){
                    SettingButton(label: "Tree Type",
                                  image: "moss-tickle-beech",
                                  prefix: "moss",
                                  data: treeTypes,
                                  mode: SettingsMode.treeType,
                                  settingKey: FirestoreKey.TREE)
            
                    
                    SettingButton(label: "Flower Type",
                                  image: "flowers/grenadier-joyful-clover",
                                  prefix: "flowers/cosmos",
                                  data: flowerTypes,
                                  mode: SettingsMode.flowerType,
                                  settingKey: FirestoreKey.FLOWER)
                        
                    
                    SettingButton(label: "Tree Color",
                                  image: "sunglow-spiky-maple",
                                  data: treeColors,
                                  mode: SettingsMode.treeColor,
                                  settingKey: FirestoreKey.TREE_COLOR)
                    
                    SettingButton(label: "Flower color",
                                  image: "petals/tangerine-savage-morel",
                                  data: flowerColors,
                                  mode: SettingsMode.flowerColor,
                                  settingKey: FirestoreKey.FLOWER_COLOR)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if let settings = UserService.user.settings {
                    reflectWeatherChanges = settings.reflectWeatherChanges
                }
            }
        }
        .navigationViewStyle(.stack)
        .foregroundColor(.black)
        .environmentObject(SettingsViewModel())
    }
}


struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
            .environmentObject(UserViewModel())
            .environmentObject(SettingsViewModel())
    }
}
