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
                Button("Done") {
                    self.settingsViewModel.updateSettings(settingKey: FirestoreKey.GARDEN_NAME, value: gardenName)
                    self.mode.wrappedValue.dismiss()
                }
                
            }
        }
    }
}

struct NameChanging_Previews: PreviewProvider {
    static var previews: some View {
        NameChanging(garden: "Wonderland")
    }
}
