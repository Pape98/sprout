//
//  GoalsSetting.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 27/06/2022.
//

import SwiftUI

// For goals setting
let goalsSettings = [
    "Steps": ["range": 0...30000.0, "step": 500, "unit": "Step(s)"],
    "Sleep": ["range": 0...24.0, "step": 1, "unit": "Hour(s)"]
]

struct GoalsSetting: View {
    
    let userDefaults = UserDefaultsService.shared
    var selectedData: [String] {
        userDefaults.getArray(key: UserDefaultsKey.DATA) ?? ["Steps","Sleep"]
    }
    
    var body: some View {
        VStack {
            PickerTitle(header: "My goals are...", subheader: "Set your daily goals 🎯")
            
            VStack(spacing: 15) {
//                ForEach(selectedData, id: \.self){ data in
//                    GoalSlider(goalName: data)
//                }
            }.padding()
            
            Spacer()
            
            BackNextButtons()
        }
    }
}

struct GoalSlider: View {
    
    @State var value: Float = 0
    var goalName: String
    
    var settings: [String: Any] {
        goalsSettings[goalName]!
    }
    
    
    var body: some View {
        VStack {
            Slider(value: $value,
                   in: settings["range"] as! ClosedRange<Float>,
                   step: settings["step"] as! Float.Stride)
            Text("\(Int(value)) \(settings["unit"] as! String)")
        }
    }
}

struct GoalsSetting_Previews: PreviewProvider {
    static var previews: some View {
        GoalsSetting()
    }
}
