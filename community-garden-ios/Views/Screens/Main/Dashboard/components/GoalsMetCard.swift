//
//  GoalsMetCard.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 12/10/2022.
//

import SwiftUI

struct GoalsMetCard: View {
    
    var goals: GoalsStat
    
    var icons = [
        DataOptions.sleep.rawValue: "bed.double",
        DataOptions.workouts.rawValue: "dumbbell",
        DataOptions.walkingRunningDistance.rawValue: "sportscourt.fill",
        DataOptions.steps.rawValue: "figure.walk"
    ]
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 8)
    
    var body: some View {
        GeometryReader { geometry in
            DashboardCard(icon: "") {
                VStack(spacing: 2) {
                    Text("Community Goals Completion")
                        .bold()
                        .bodyStyle()
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(0..<8){ i in
                            DataItem(width: geometry.size.width * 0.1,
                                     opacity: i < goals.numberOfGoalsAchieved ? 1 : 0.125,
                                     icon: i < goals.numberOfGoalsAchieved ?  icons[goals.trackedData[i]]! : "")
                        }
                    }.padding()
                }

            }
        }
    }
    
    @ViewBuilder
    func DataItem(width: CGFloat, opacity: Double, icon: String = "") -> some View {
        ZStack {
            Circle()
                .fill(Color.appleGreen)
                .opacity(opacity)
                .frame(width: width)
            
            if icon != "" {
                Image(systemName: icon)
                    .foregroundColor(Color.white)
            }
        }
    }
}

struct GoalsMetCard_Previews: PreviewProvider {
    
    static var goals = GoalsStat(numberOfGoalsAchieved: 2, date: "2002", group: 0, trackedData: ["Steps", "Workout Time"])
    static var previews: some View {
        
        VStack {
            GoalsMetCard(goals: goals)
        }
        .background(Color.hawks)
        .environmentObject(GardenViewModel())
        
    }
}
