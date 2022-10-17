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
    
    @State var selectedData: String = HistoryViewModel.Data.steps.rawValue
    
    var body: some View {
        VStack {
            
            Text("Tap below to select data 😊")
                .foregroundColor(appViewModel.fontColor)
            Picker("Data",selection: $selectedData){
                ForEach(HistoryViewModel.Data.dalatList, id: \.self){ text in
                    if isUserTrackingData(DataOptions(rawValue: text)!) {
                        Text(text.capitalized)
                            .font(.custom("Baloo2-medium", size: 14))
                            .tag(text)
                    }
                }
            }
            
            ScrollView {
                VStack {
                    if let dataList = historyViewModel.dataMapping[selectedData] {
                        ForEach(dataList, id: \.id){ item in
                            DataStatus(data: item)
                        }
                    }
                }
                .padding()
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
