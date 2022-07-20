//
//  SettingsPicker.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 16/07/2022.
//

import SwiftUI

struct SettingPicker: View {
    
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var selection = ""
    @State var showAlert = false
    var title: String
    var prefix: String = ""
    var data: [String]
    var mode: SettingsMode
    var settingKey: FirestoreKey
    
    var body: some View {
        ZStack {
            MainBackground()
            VStack {
                List {
                    if let settings = settingsViewModel.settings {
                        ForEach(data, id: \.self){ item in
                            Row(label: formatItemName(item).lowercased(), image: "\(prefix)-\(item)", settings: settings)
                        }
                    }
                }
                .alert(isPresented: $showAlert){
                    Alert(title: Text(title),
                          message: Text("\(title) has been updated to \(selection) 😊"),
                          dismissButton: .default(Text("Got it!")))
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
    
    @ViewBuilder
    func Row(label: String, image: String, settings: UserSettings) -> some View {
        
        
        var imageName: String {
            switch mode {
            case SettingsMode.flowerColor:
                let flowerName = addDash(settings.flower)
                return "petals/\(label)-\(flowerName)"
            case .treeColor:
                let treeName = addDash(settings.tree)
                return "\(label)-\(treeName)"
            default:
                return image
            }
        }
        
        return HStack {
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding()
            
            Text(label)
            Spacer()
            
            if selection == label {
                Image(systemName: "checkmark")
                    .foregroundColor(.appleGreen)
                    .padding(.trailing)
            }
        }
        .onTapGesture {
            selection = label
            settingsViewModel.updateSettings(settingKey: settingKey, value: selection)
            showAlert = true
            self.presentationMode.wrappedValue.dismiss()
            
        }
    }
}


struct SettingPicker_Previews: PreviewProvider {
    static var trees = Constants.trees
    static var colors = Constants.colors
    static var previews: some View {
        SettingPicker(title: "Tree Type", prefix: "moss", data: colors, mode: SettingsMode.treeType, settingKey: FirestoreKey.TREE)
    }
}
