//
//  Settings.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 04/07/2022.
//

import SwiftUI

struct Settings: View {
    
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @StateObject var settingsViewModel: SettingsViewModel = SettingsViewModel()
    
    @State private var reflectWeatherChanges = false
    var treeTypes = Constants.trees
    var flowerTypes = Constants.flowers
    var treeColors = Constants.colors
    var flowerColors = Constants.colors.filter { $0 != "moss"}
    
    var body: some View {
        NavigationView {
            ZStack {
                MainBackground()
                List {
                    Section("Garden"){
                        
                        NavigationLink {
                            if let settings = settingsViewModel.settings {
                                NameChanging(garden: settings.gardenName)
                            }
                        } label : {
                            Text("Garden Name")
                        }
                        
                        Toggle("Reflect weather changes", isOn: $reflectWeatherChanges)
                            .tint(.appleGreen)
                            .onChange(of: reflectWeatherChanges) { newValue in
                                
                                guard settingsViewModel.settings != nil else { return }
                                settingsViewModel.settings!.reflectWeatherChanges = newValue
                                settingsViewModel.updateSettings(settingKey: FirestoreKey.REFLECT_WEATHER_CHANGES, value: newValue)
                            }
                    }
                    
                    Section("Types & Colors"){
                        if let settings = settingsViewModel.settings {
                            SettingButton(label: "Tree Type",
                                          image: "moss-\(addDash(settings.tree))",
                                          prefix: "moss",
                                          data: treeTypes,
                                          mode: SettingsMode.treeType,
                                          settingKey: FirestoreKey.TREE)
                            
                            
                            SettingButton(label: "Flower Type",
                                          image: "flowers/cosmos-\(addDash(settings.flower))",
                                          prefix: "flowers/cosmos",
                                          data: flowerTypes,
                                          mode: SettingsMode.flowerType,
                                          settingKey: FirestoreKey.FLOWER)
                            
                            
                            SettingButton(label: "Tree Color",
                                          image: addDash("\(settings.treeColor)-\(settings.tree)"),
                                          data: treeColors,
                                          mode: SettingsMode.treeColor,
                                          settingKey: FirestoreKey.TREE_COLOR)
                            
                            SettingButton(label: "Flower color",
                                          image: "petals/" + addDash("\(settings.flowerColor)-\(settings.flower)"),
                                          data: flowerColors,
                                          mode: SettingsMode.flowerColor,
                                          settingKey: FirestoreKey.FLOWER_COLOR)
                        }
                        
                    }
                }
                .opacity(0.95)
                .offset(y: -15)
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    if let settings = UserService.user.settings {
                        reflectWeatherChanges = settings.reflectWeatherChanges
                    }
                    
                    settingsViewModel.fetchSettings()
                }
                
            }
            .toolbar {
                Button("Logout"){
                    authViewModel.signOut()
                }
                .foregroundColor(.red)
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
            .previewInterfaceOrientation(.portraitUpsideDown)
    }
}
