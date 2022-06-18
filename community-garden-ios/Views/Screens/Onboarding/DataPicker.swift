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
    let dataOptions = DataOptions.dalatList
    
    
    var body: some View {
        VStack {
            Text("I want to track ...")
                .headerStyle()
            Text("Select two things from the Health App")
                .bodyStyle()
            
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
                onboardingRouter.setScreen(.chooseTree)
            }
            .padding()
            .frame(maxWidth: 250)
            
            
        }.alert("Already Selected", isPresented: $showingAlert){
            Button("OK", role: .cancel){}
        }
    }
}

struct DataCard: View {
    
    var data: String
    var isSelected: Bool
    var icon: String {
        DataOptions.icons[data]!
    }
    var background: Color {
        isSelected ? .teaGreen : .white
    }
    
    var opacity: CGFloat {
        isSelected ? 0.9 : 0.6
    }
    
    var selectedColor: Color {
        isSelected ? .white : .seaGreen
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(background)
                .opacity(opacity)
            HStack {
                
                VStack(alignment: .leading, spacing:10) {
                    Text(data)
                        .bold()
                        .font(.title3)
                        .foregroundColor(.seaGreen)
                    Text("Track your data")
                        .bodyStyle()
                    
                }.padding()
                
                Spacer()
                
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .foregroundColor(selectedColor)
                
            }
        }
        .frame(height: 80)
        .cornerRadius(10)
    }
}

struct DataPicker_Previews: PreviewProvider {
    static var previews: some View {
        DataPicker()
            .environmentObject(OnboardingRouter())
            .background(Color.chalice)
    }
}
