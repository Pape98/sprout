//
//  StepView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/19/21.
//

import SwiftUI

struct StepView: View {
    
    @EnvironmentObject var userModel: UserModel
    var steps: [Step] = [Step(date: "22-12-1998", count: 25), Step(date: "15-08-2024", count: 41)]
    
    var body: some View {
        NavigationView {
            ZStack {
//                List(steps) { steps in
//                    Group {
//                        Text()
//                    }
//                }
                VStack {
                    Spacer()
                    Image("tree")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 500)
                }
            }
            .navigationTitle("Your Steps")
            .fullBackground(imageName: "island-background")
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
