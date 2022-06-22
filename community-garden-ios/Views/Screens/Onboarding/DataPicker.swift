//
//  PickData.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 18/06/2022.
//

import SwiftUI

struct DataPicker: View {
    
    @State var selections: [String] = []
    @State var showingAlert = false
    @EnvironmentObject var onboardingRouter: OnboardingRouter
    
    let userDefaultsService: UserDefaultsService = UserDefaultsService.shared
    
    let header = "I want to track ..."
    let subheader = "Select two things from the Health App"
    let dataOptions = DataOptions.dalatList
    
    
    var body: some View {
        VStack {
            PickerTitle(header: header, subheader: subheader)
            
            VStack(spacing: 15) {
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
            
            Spacer()
            
            PickerButton(text: "Next"){
                if selections.isEmpty {
                    showingAlert = true
                } else {
                    // Save user wants to track
                    userDefaultsService.save(value: selections, key: UserDefaultsKey.DATA)
                    // Redirect to next screen
                    onboardingRouter.setScreen(.chooseTree)
                }
            }
            .frame(maxWidth: 250)
            
            
        }.alert("Must select at least 1 😊", isPresented: $showingAlert){
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
