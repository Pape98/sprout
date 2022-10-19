//
//  History.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 23/08/2022.
//

import SwiftUI

enum HistoryViewType {
    case personal, community
}

struct History: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var communityViewModel: CommunityViewModel
    
    @State var historyView: HistoryViewType = .personal
    
    
    var body: some View {
        NavigationView {
            ZStack {
                MainBackground()
                
                VStack {
                    Picker("", selection: $historyView){
                        Text("Personal")
                            .tag(HistoryViewType.personal)
                        Text("Community").tag(HistoryViewType.community)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    if historyView == .personal { PersonalHistory() }
                    else { CommunityHistory() }
                    Spacer()
                }
                
                FloatingAnimal(animal: "penguin-waving-hello")
            }
            .navigationBarTitle("History", displayMode: .inline)
            
        }
        .onAppear {
            appViewModel.setBackground()
        }
        .navigationViewStyle(.stack)
    }
}

struct History_Previews: PreviewProvider {
    static var previews: some View {
        History()
            .environmentObject(HistoryViewModel())
            .environmentObject(AppViewModel())
    }
}
