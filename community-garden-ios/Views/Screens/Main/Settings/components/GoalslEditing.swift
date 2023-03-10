//
//  GoalslEditing.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 03/10/2022.
//

import SwiftUI

struct GoalslEditing: View {
    
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    let keys = Array(GoalsSettings.defaultsKeys.keys).sorted()
    
    var body: some View {
        ZStack {
            MainBackground()
            
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(keys, id: \.self) { key in
                        if isUserTrackingData(DataOptions(rawValue: key)!){
                            GoalEditingSlider(key: key)
                        }
                    }
                }
                .padding()
            }
            Spacer()
        }
        .navigationTitle("Goals Setting")
    }
    
}

struct GoalEditingSlider: View {
    
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var key: String
    var firestoreKey: FirestoreKey {
        GoalsSettings.defaultsKeys[key]!
    }
    
    var currentGoal: Float {
        let settings = UserService.shared.user.settings!
        let dataOption = DataOptions(rawValue: key)
        
        switch dataOption {
        case .sleep:
            return Float(Int(settings.sleepGoal! / 60))
        case .steps:
            return Float(settings.stepsGoal!)
        case .walkingRunningDistance:
            return Float(settings.walkingRunningGoal!)
        case .workouts:
            return Float(settings.workoutsGoal!)
        default:
            return 0
        }
    }
    
    @State private var oldValue: Float = 0
    @State private var value: Float = 0
    @State private var isEditing = false
    
    var body: some View {
        VStack(spacing: 10) {
            Text(key)
                .font(.custom(Constants.mainFont, size: 20))
                .bold()
            Slider(
                value: $value,
                in: GoalsSettings.ranges[key]!,
                step: GoalsSettings.steps[key]!,
                onEditingChanged: { editing in
                    isEditing = editing
                }
            )
            .tint(.appleGreen)
            .onChange(of: isEditing) { newValue in
                if newValue == true {
                    oldValue = value
                } else if newValue == false {
                    settingsViewModel.updateSettings(settingKey: firestoreKey, value: value)
                    SproutAnalytics.shared.goalChange(goal: firestoreKey.rawValue, old: oldValue, new: value)
                    print(value)
                }
            }
            
            Text("\(Int(value)) \(GoalsSettings.labels[key]!)")
                .bodyStyle()
        }
        .padding()
        .background(Color.white)
        .opacity(0.8)
        .cornerRadius(10)
        .onAppear {
            oldValue = currentGoal
            value = currentGoal
        }
    }
}

struct GoalslEditing_Previews: PreviewProvider {
    static var previews: some View {
        GoalslEditing()
            .environmentObject(SettingsViewModel())
    }
}
