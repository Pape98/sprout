//
//  StepView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/19/21.
//

import SwiftUI

struct StepView: View {
    
    @EnvironmentObject var userModel: UserModel
    
    var steps: [Step]?
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    
                    LazyVGrid (columns: columns, spacing: 20){
                        if steps != nil {
                            ForEach(steps!) { step in
                                ProgressTriangle(step: step)
                            }
                        } else {
                            ForEach(userModel.currentUserData.steps) { step in
                                ProgressTriangle(step: step)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Your Steps")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct StepView_Previews: PreviewProvider {
    
    @State static var steps: [Step] = [Step(date: "22-12-1998", count: 894),
                                       Step(date: "15-08-2024", count: 1500),
                                       Step(date: "22-12-1998", count: 2060),
                                       Step(date: "15-08-2024", count: 100)]
    
    static var previews: some View {
        StepView(steps: steps)
            .environmentObject(UserModel())
    }
}
