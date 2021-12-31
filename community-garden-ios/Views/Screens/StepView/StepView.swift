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
            VStack {
                Text("Steps View")
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
