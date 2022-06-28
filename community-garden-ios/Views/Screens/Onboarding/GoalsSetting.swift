//
//  GoalsSetting.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 27/06/2022.
//

import SwiftUI

// For goals setting
struct GoalsSetting: View {
    
    let userDefaults = UserDefaultsService.shared
    var selectedData: [String] {
        userDefaults.get(key: UserDefaultsKey.DATA) ?? ["Steps","Sleep"]
    }
    
    var body: some View {
        VStack {
            PickerTitle(header: "My goals are...", subheader: "Set your daily goals 🎯")
            
            VStack(spacing: 15) {
                ForEach(selectedData, id: \.self){ data in
                    GoalSlider(goalName: data)
                }
            }.padding()
            
            Spacer()
            
            BackNextButtons()
        }
    }
}

struct GoalSlider: View {
    
    @State var value: Float = 0
    var goalName: String
    var defaultKey: UserDefaultsKey {
        GoalsSettings.defaultsKeys[goalName]!
    }
    let userDefaults = UserDefaultsService.shared
    
    var body: some View {
        VStack(spacing: 10) {
            Text(GoalsSettings.titles[goalName]!)
                .font(.title3)
                .foregroundColor(.seaGreen)
                .bold()
            Slider(
                value: $value,
                in: GoalsSettings.ranges[goalName]!,
                step: GoalsSettings.steps[goalName]!
            )
            .tint(.appleGreen)
            .onChange(of: value) { newValue in
                userDefaults.save(value: value, key: defaultKey)
            }
            
            Text("\(Int(value)) \(GoalsSettings.labels[goalName]!)")
                .bodyStyle()
        }.padding()
        .background(Color.white)
        .opacity(0.8)
        .cornerRadius(10)
    }
}

struct GoalsSetting_Previews: PreviewProvider {
    static var previews: some View {
        GoalsSetting()
            .background(Color.hawks)
    }
}
