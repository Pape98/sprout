//
//  GoalsMetCard.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 12/10/2022.
//

import SwiftUI

struct GoalsMetCard: View {
    
    @EnvironmentObject var communityViewModel: CommunityViewModel
    
    var goals: GoalsStat?
    
    var icons = [
        DataOptions.sleep.rawValue: "bed.double",
        DataOptions.workouts.rawValue: "dumbbell",
        DataOptions.walkingRunningDistance.rawValue: "sportscourt.fill",
        DataOptions.steps.rawValue: "figure.walk"
    ]
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 8)
    var totalNumberOfGoals: Int {
        (communityViewModel.members.count + 1) * 2
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 2) {
                    Text("Community Goals Completion")
                        .bold()
                        .bodyStyle()
                        .padding(.top)
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(0..<totalNumberOfGoals, id: \.self){ i in
                            if let goals = goals {
                                DataItem(width: geometry.size.width * 0.1,
                                         opacity: i < goals.numberOfGoalsAchieved ? 1 : 0.125,
                                         icon: i < goals.numberOfGoalsAchieved ?  icons[goals.trackedData[i]]! : "")
                            } else {
                                DataItem(width: geometry.size.width * 0.1,
                                         opacity: 0.125, icon: "questionmark")
                            }
                            
                        }
                    }.padding()
                }
                
            }
            .background{
                Rectangle()
                    .fill(.white)
                    .cornerRadius(10)
                    .opacity(0.9)
                    .frame(maxWidth: .infinity)
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
