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
                            ForEach(steps!, id: \.id) { step in
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
    
    @State static var steps: [Step] = [Step(date: Date.now, count: 894),
                                       Step(date: Date.now, count: 1500),
                                       Step(date: Date.now, count: 2060),
                                       Step(date: Date.now, count: 100)]
    
    static var previews: some View {
        StepView(steps: steps)
            .environmentObject(UserModel())
    }
}
