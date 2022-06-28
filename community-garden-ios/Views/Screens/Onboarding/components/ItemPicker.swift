//
//  Picker.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 6/15/22.
//

import SwiftUI

struct ItemPicker: View {
    
    @Environment(\.userDefaultsKey) var userDefaultsKey
    @EnvironmentObject var onboardingRouter: OnboardingRouter
    
    
    var header: String
    var subheader: String
    @Binding var selection: String
    var options: [String]
    var circleType: PickerCard.CircleType
    
    let userDefaults = UserDefaultsService.shared
    let rows = [
        GridItem(.flexible()),
    ]
    
    
    var body: some View {
        // Content
        GeometryReader { geometry in
            
            ZStack(alignment: .top) {
                
                // Heading
                VStack {
                    
                    VStack {
                        PickerTitle(header: header, subheader: subheader)
                        
                        SelectionImage(selection: selection, circleType: circleType)
                            .padding(10)
                        
                        
                        ScrollView(.horizontal, showsIndicators: false){
                            LazyHGrid(rows: rows, spacing: 15){
                                ForEach(options, id: \.self){ option in
                                    PickerCard(option: option, circleType: circleType, isSelected: selection == option)
                                        .frame(width: 150, height: 150)
                                        .cornerRadius(10)
                                        .onTapGesture {
                                            selection = option
                                            userDefaults.save(value: selection, key: userDefaultsKey)
                                        }
                                }
                            }
                        }
                        .padding(.leading)
                        .frame(height: 150)
                        .offset(y: 30)
                    }
                    .padding()
                    
                    Spacer()
                    
                    
                    BackNextButtons()
                        .environmentObject(onboardingRouter)
                }
                
            }
            .onAppear {
                userDefaults.save(value: selection, key: userDefaultsKey)
            }
        }
    }
}

struct SelectionImage: View {
    var selection: String
    var circleType: PickerCard.CircleType
    var colorPrefix: String {
        circleType == PickerCard.CircleType.TREE ? "moss" : "cosmos"
    }
    
    var body: some View {
        if(circleType == PickerCard.CircleType.TREE){
            CircledTree(
                option: "\(colorPrefix)-\(selection)",
                background: .oliveGreen,
                size: 200
            )
        } else {
            CircledFlower(option: "\(colorPrefix)-\(selection)",
                          background: .oliveGreen,
                          size: 130
            )
        }
    }
}

struct Picker_Previews: PreviewProvider {
    
    @State static var selection = "spiky-maple"
    static var previews: some View {
        
        ItemPicker(header: "Choose your tree!",
                   subheader: "This will be used to track your steps",
                   selection: $selection,
                   options: Constants.trees,
                   circleType: PickerCard.CircleType.TREE)
        .environmentObject(OnboardingRouter())
        
    }
}
