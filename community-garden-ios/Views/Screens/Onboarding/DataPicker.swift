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
                    onboardingRouter.setScreen(.chooseTree)
                }
            }
            .frame(maxWidth: 250)
            
            
        }.alert("Must select at least 1 😊", isPresented: $showingAlert){
            Button("OK", role: .cancel){}
        }.padding()
    }
}

struct DataCard: View {
    
    var data: String
    var isSelected: Bool
    var metadata: [String] {
        DataOptions.icons[data]!
    }
    var background: Color {
        isSelected ? .teaGreen : .white
    }
    
    var opacity: CGFloat {
        isSelected ? 0.8 : 0.6
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
                    
                    Text(metadata[1])
                        .bodyStyle()
                    
                    
                    
                }.padding()
                
                Spacer()
                
                Image(systemName: metadata[0])
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .foregroundColor(selectedColor)
                
            }
        }
        .frame(maxHeight: 90)
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
