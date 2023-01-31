//
//  PersonalHistory.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 17/10/2022.
//

import SwiftUI

struct PersonalHistory: View {
    
    @EnvironmentObject var historyViewModel: HistoryViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    
    // TODO: Fix later
    @State var selectedData: String = HistoryViewModel.Data.steps.rawValue
    
    var body: some View {
        VStack {
            
            Text("Tap below to select data 😊")
                .foregroundColor(appViewModel.fontColor)
            Picker("Data",selection: $selectedData){
                ForEach(UserService.shared.user.settings!.data, id: \.self){ text in
                    if isUserTrackingData(DataOptions(rawValue: text)!) {
                        Text(text.capitalized)
                            .font(.custom(Constants.mainFont, size: 14))
                            .tag(text)
                    }
                }
            }
            .onAppear {
                guard let settings = UserService.shared.user.settings else { return }
                selectedData = settings.data[0]
            }
            
            ScrollView {
                VStack {
                    if let dataList = historyViewModel.dataMapping[selectedData] {
                        ForEach(dataList, id: \.id){ item in
                            NavigationLink {
                                DayHistory(data: item)
                            } label: {
                                DataStatus(data: item)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .clipped()
            
        }
    }
}

struct PersonalHistory_Previews: PreviewProvider {
    static var previews: some View {
        PersonalHistory()
            .environmentObject(AppViewModel())
            .environmentObject(HistoryViewModel())
    }
}
