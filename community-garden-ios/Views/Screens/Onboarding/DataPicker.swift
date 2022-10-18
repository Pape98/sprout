//
//  PickData.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 18/06/2022.
//

import SwiftUI

struct DataPicker: View {
    
    // MARK: Properties
    @State private var selections: [String] = []
    @State private var showingAlert = false
    @EnvironmentObject var onboardingRouter: OnboardingRouter
    
    let header = "I want to track ..."
    let subheader = "Select two things from the Health App"
    let dataOptions = DataOptions.dalatList
    
    // MARK: Views
    var body: some View {
        VStack {
            PickerTitle(header: header, subheader: subheader)
            
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(dataOptions, id:\.self){ title in
                        DataCard(data: title, isSelected: selections.contains(title))
                            .onTapGesture {
                                // Deselect Item
                                if selections.contains(title) {
                                    selections = selections.filter {$0 != title}
                                    // Select Item
                                } else {
                                    selections.append(title)
                                }
                            }
                    }
                }
                .padding()
            }
            
            Spacer()
            
            PickerButton(text: "Next"){
                if selections.count != 2 {
                    showingAlert = true
                } else {
                    // Save user wants to track
                    onboardingRouter.saveSetting(key: FirestoreKey.DATA, value: selections)
                    // Redirect to next screen
                    onboardingRouter.setScreen(.setGoals)
                }
            }
            .frame(maxWidth: 250)
            
            
        }.alert("Must select exactly 2 😊", isPresented: $showingAlert){
            Button("OK", role: .cancel){}
        }.padding()
    }
}

struct DataPicker_Previews: PreviewProvider {
    static var previews: some View {
        DataPicker()
            .environmentObject(OnboardingRouter())
            .background(Color.white)
    }
}
