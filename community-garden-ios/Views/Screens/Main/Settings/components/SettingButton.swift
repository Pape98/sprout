//
//  SettingButton.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 16/07/2022.
//

import SwiftUI

struct SettingButton: View {
    
    var label: String
    var image: String
    var prefix: String = ""
    var data: [String]
    var mode: SettingsMode
    var settingKey: FirestoreKey
    
    var body: some View {
        
        NavigationLink {
            SettingPicker(title: label,
                          prefix: prefix,
                          data: data,
                          mode: mode,
                          settingKey: settingKey)
        } label: {
            HStack{
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                
                Text(label)
                Spacer()
            }
        }
    }
}

struct SettingButton_Previews: PreviewProvider {
    static var trees = Constants.trees
    
    static var previews: some View {
        SettingButton(label: "Change tree", image: "moss-tickle-beech", data: trees, mode: SettingsMode.treeType, settingKey: FirestoreKey.TREE)
    }
}
