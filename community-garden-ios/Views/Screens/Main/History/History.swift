//
//  History.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 23/08/2022.
//

import SwiftUI



struct History: View {
    
    @EnvironmentObject var historyViewModel: HistoryViewModel
    @State var selectedData: String = HistoryViewModel.Data.steps.rawValue
    
    var gridItemLayout = Array(repeating: GridItem(.flexible()), count: 4)
    
    var body: some View {
        NavigationView {
            ZStack {
                MainBackground()
                
                VStack {
                    
                    Text("Tap below to select data 😊")
                    Picker("Data",selection: $selectedData){
                        ForEach(HistoryViewModel.Data.dalatList, id: \.self){ text in
                            if isUserTrackingData(DataOptions(rawValue: text)!) {
                                Text(text.capitalized)
                                    .bold()
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
