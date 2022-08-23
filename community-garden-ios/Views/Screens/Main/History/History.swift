//
//  History.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 23/08/2022.
//

import SwiftUI

struct History: View {
    
    @EnvironmentObject var historyViewModel: HistoryViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                MainBackground()
                
                
                List {
                    Section("Steps"){
                        ForEach(historyViewModel.steps){ step in
                            HStack{
                                Text(step.date)
                                Spacer()
                                Text("\(step.count)")
                            }
                        }
                    }
                    
                    Section("Workouts"){
                        ForEach(historyViewModel.workouts){ workout in
                            HStack{
                                Text(workout.date)
                                Spacer()
                                Text("\(workout.duration)")
                            }
                        }
                    }
                }
                
                
            }
            .navigationBarTitle("History", displayMode: .inline)
        }
        .navigationViewStyle(.stack)
    }
}

struct History_Previews: PreviewProvider {
    static var previews: some View {
        History()
            .environmentObject(HistoryViewModel())
    }
}
