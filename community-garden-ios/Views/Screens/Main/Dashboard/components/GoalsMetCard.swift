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
        DataOptions.workouts.rawValue: "bicycle",
        DataOptions.walkingRunningDistance.rawValue: "sportscourt.fill",
        DataOptions.steps.rawValue: "figure.walk"
    ]
    
    let columns: [GridItem] = [GridItem(.adaptive(minimum: 40))]
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
                            if goals != nil && i < goals!.trackedData.count {
                                DataItem(width: geometry.size.width * 0.125,
                                         opacity: i < goals!.numberOfGoalsAchieved ? 1 : 0.125,
                                         icon: i < goals!.numberOfGoalsAchieved ?  icons[goals!.trackedData[i]]! : "")
                            } else {
                                DataItem(width: geometry.size.width * 0.125,
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
                .frame(width: width, height: width)
            
            if icon != "" {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: width * 0.65, height: width * 0.65)
                    .padding()
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
        .environmentObject(CommunityViewModel())
        
    }
}
