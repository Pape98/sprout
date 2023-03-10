//
//  NameChanging.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 7/19/22.
//

import SwiftUI

struct NameChanging: View {

    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State private var gardenName: String
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var appViewModel: AppViewModel

    init(garden: String){
        _gardenName = State(initialValue: garden)
        
    }
        
    var body: some View {
        ZStack {
            MainBackground()
            Form {
                Section( "Garden Name") {
                    TextField("", text: $gardenName)
                }
            }
            .modifier(ListBackgroundModifier())
        }
        .navigationTitle("Names")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("Save") {
                    self.settingsViewModel.updateSettings(settingKey: FirestoreKey.GARDEN_NAME, value: gardenName)
                    self.mode.wrappedValue.dismiss()
                }
                .foregroundColor(appViewModel.fontColor)
                
            }
        }
    }
}

struct NameChanging_Previews: PreviewProvider {
    static var previews: some View {
        NameChanging(garden: "Wonderland")
            .environmentObject(AppViewModel())
    }
}
