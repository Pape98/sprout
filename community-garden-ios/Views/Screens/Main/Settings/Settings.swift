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
    @State var isMusicOn: Bool = true
    
    @State private var reflectWeatherChanges = false
    var treeTypes = Constants.trees
    var flowerTypes = Constants.flowers
    var treeColors = Constants.colors
    var flowerColors = Constants.colors.filter { $0 != "moss"}
    let userDefaults = UserDefaultsService.shared
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                MainBackground()

                List {
                    
                    Section(header: Text("System").foregroundColor(appViewModel.fontColor)){
                        
                        // Music on/off toggle
                        Toggle(isOn: $isMusicOn) {
                                Text("Turn on background music")
                            }
                        .onAppear {
                            if let musicOn: Bool = userDefaults.get(key: UserDefaultsKey.IS_MUSIC_ON) {
                                isMusicOn = musicOn
                            }
                        }
                        .onChange(of: isMusicOn) { newValue in
                            userDefaults.save(value: newValue, key: UserDefaultsKey.IS_MUSIC_ON)
                            if newValue == true { AudioPlayer.shared.startBackgroundMusic() }
                            else { AudioPlayer.shared.stopBackgroundMusic()}
                        }
                        
                        if appViewModel.isBadgeUnlocked(UnlockableBadge.music) {
                            NavigationLink {
                              MusicList()
                            } label: {
                                Text("Select default song")
                            }
                        }
                    }
                    
                    Section(header: Text("Data").foregroundColor(appViewModel.fontColor)){
                        NavigationLink {
                            if let _ = settingsViewModel.settings {
                                GoalslEditing()
                            }
                        } label : {
                            Text("Edit goals")
                        }
                    }
                    
                    if appViewModel.canCustomize {
                        Section(header: Text("Garden").foregroundColor(appViewModel.fontColor)){
                            
                            NavigationLink {
                                if let settings = settingsViewModel.settings {
                                    NameChanging(garden: settings.gardenName)
                                }
                            } label : {
                                Text("Change garden name")
                            }
                        }
                        
                        Section(header: Text("Types & Colors").foregroundColor(appViewModel.fontColor)){
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
                .padding(.vertical, 0)
                .modifier(ListBackgroundModifier())
                .opacity(0.95)
//                .offset(y: -15)
                .navigationBarTitle (Text("Settings ⚙️"), displayMode: .inline)
                .onAppear {
                    if let settings = UserService.shared.user.settings {
                        reflectWeatherChanges = settings.reflectWeatherChanges
                    }
                    
                    settingsViewModel.fetchSettings()
                }
                
                FloatingAnimal(animal: "sleeping-bear")
            }
            .toolbar {
                Button("Logout"){
                    authViewModel.signOut()
                    AudioPlayer.shared.stopBackgroundMusic()
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
