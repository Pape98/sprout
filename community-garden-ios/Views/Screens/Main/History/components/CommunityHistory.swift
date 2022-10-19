//
//  CommunityHistory.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 17/10/2022.
//

import SwiftUI

struct CommunityHistory: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var historyViewModel: HistoryViewModel
    @EnvironmentObject var communityViewModel: CommunityViewModel
    
    var numFiftyPercentDays: Int {
        var count = 0
        
        for stat in historyViewModel.communityGoalsStat {
            if Double(stat.numberOfGoalsAchieved / (numOfMembers * 2)) >= 0.5 {
                count += 1
            }
        }
        
        return count
    }
    
    var numOfMembers: Int {
        communityViewModel.members.count
    }
    
    var body: some View {
        VStack {
            
            VStack(spacing: 2) {
                Text("Number of days with at least 50% community goal achievements")
                    .bodyStyle(foregroundColor: .black, size: 16)
                    .multilineTextAlignment(.center)
                
                Text("\(numFiftyPercentDays) day(s)")
                    .bodyStyle(foregroundColor: .appleGreen, size: 20)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .opacity(0.5)
            }
            .padding()
            
            ScrollView {
                VStack {
                    ForEach(historyViewModel.communityGoalsStat) { goalStat in
                        CommunityProgressCard(goalStat: goalStat)
                    }
                }
                .padding()
            }
        }
    }
}

struct CommunityProgressCard : View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var communityViewModel: CommunityViewModel
    
    var goalStat: GoalsStat
    
    var numOfMembers: Int {
        communityViewModel.members.count
    }
    
    var progress: Double {
        Double(goalStat.numberOfGoalsAchieved / (numOfMembers * 2))
    }
    var face: String {
        if progress >= 0.5 {
            return "happy"
        }
        
        return "sad"
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Image("faces/\(face)")
            Text("\(Int(progress * 100))%")
                .bodyStyle(foregroundColor: appViewModel.fontColor, size: 22)
            Spacer()
            
            Text("\(goalStat.date)")
                .bodyStyle(foregroundColor: appViewModel.fontColor)
        }
        .padding()
    }
    
}

struct CommunityHistory_Previews: PreviewProvider {
    static var previews: some View {
        CommunityHistory()
            .environmentObject(HistoryViewModel())
            .foregroundColor(.black)
    }
}
