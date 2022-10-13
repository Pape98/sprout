//
//  Settings.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 04/07/2022.
//

import SwiftUI

struct Settings: View {
    
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var appViewModel: AppViewModel
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
                    
                    Section("Data"){
                        NavigationLink {
                            if let _ = settingsViewModel.settings {
                                GoalslEditing()
                            }
                        } label : {
                            Text("Edit Goals")
                        }
                    }
                    
                    if RemoteConfiguration.shared.canCustomize(group: UserService.shared.user.group){
                        Section("Garden"){
                            
                            NavigationLink {
                                if let settings = settingsViewModel.settings {
                                    NameChanging(garden: settings.gardenName)
                                }
                            } label : {
                                Text("Edit Garden Name")
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
                }
                .modifier(ListBackgroundModifier())
                .opacity(0.95)
                .offset(y: -15)
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    
                    appViewModel.setBackground()
                    if let settings = UserService.shared.user.settings {
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
            .environmentObject(AppViewModel())
            .previewInterfaceOrientation(.portraitUpsideDown)
    }
}
