//
//  StepView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/19/21.
//

import SwiftUI

struct StepView: View {
    
    @EnvironmentObject var userModel: UserModel
//    let steps: [Step] = [Step(date: "22-12-1998", count: 300), Step(date: "15-08-2024", count: 450)]
    let stepsGoal = 2500.0
    
    var body: some View {
        let steps = userModel.currentUserData.steps

        NavigationView {
            ZStack {
                
                Image("island-background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
                VStack {
                    
                    if let latestStep = steps.first {
                        let length = Double(500 * latestStep.count) / stepsGoal
                        let displayLength = length > stepsGoal ? stepsGoal : length
                        
                        VStack {
                            Image("tree")
                                .resizable()
                        }
                        .frame(width:displayLength, height:displayLength)
                    }
                    
                    if let latestStep = steps.first {
                        Text(latestStep.date)
                            .padding()
                        Text("\(latestStep.count)/\(stepsGoal) steps")
                            .padding()
                    }
                }
            }
            .navigationTitle("Your Steps")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct StepView_Previews: PreviewProvider {
    static var previews: some View {
        StepView()
            .environmentObject(UserModel())
    }
}
