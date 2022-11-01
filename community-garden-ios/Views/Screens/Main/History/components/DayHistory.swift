//
//  DayHistory.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 10/31/22.
//

import SwiftUI
import SpriteKit
import SwiftDate

struct DayHistory: View {
    
    @ObservedObject var dataHistoryViewModel: DataHistoryViewModel = DataHistoryViewModel.shared
    
    var scene: SKScene {
        let scene = GardenHistoryScene()
        scene.scaleMode = .resizeFill
        return scene
    }
    
    var mapping: [String: String] {
        guard let settings = UserService.shared.user.settings else { return ["Flower": "","Tree":""]}
        return settings.mappedData
    }
    
    
    var data: HealthData
    
    var formattedDate: String {
        let region = Region(zone: Zones.americaNewYork)
        let date = DateInRegion(data.date, region: region)!.date.getFormattedDate(format: "MMM d, yyyy")
        return date
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // MARK: SpriteKit view
                SpriteView(scene: scene, options: [.allowsTransparency])
                    .ignoresSafeArea(.container, edges:[.top])
                    .weatherOverlay()
                    .onAppear {
                        // SproutAnalytics.shared.viewOwnGarden()
                        dataHistoryViewModel.getUserItemsByDate(date: data.date)
                    }
                    .onDisappear {
                        dataHistoryViewModel.historyItems = []
                    }
                    .navigationTitle(formattedDate)
                    .navigationBarTitleDisplayMode(.inline)
                
                // MARK: Card
                
                ZStack {
                    HistoryCard(data: data)
                        .padding()
                        .frame(width: geo.size.width * 0.4, height: geo.size.height * 0.3)
                }
                .frame(width: geo.size.width, height: geo.size.height, alignment: .topTrailing)
                
                ZStack {
                    Labels()
                        .frame(width: geo.size.width * 0.3, height: geo.size.height * 0.1)
                        .offset(y: -geo.size.height * 0.025)
                }
                .padding()
                .frame(width: geo.size.width, height: geo.size.height, alignment: .bottomLeading)
            }
            .onAppear {
                SproutAnalytics.shared.viewIndividualHistoryPage(data: data.label, date: data.date)
            }
        }
    }
    
    @ViewBuilder func Labels() -> some View {
   
            ZStack {
                Color.white.opacity(0.6)
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Image("droplet-icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        Text(mapping["Tree"]!)
                            .bodyStyle(size: 12)
                            .lineLimit(nil)
                    }
                    HStack {
                        Image("seed-icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        Text(mapping["Flower"]!)
                            .bodyStyle(size: 12)
                            .lineLimit(2)
                    }
                }.padding()
            }
            .cornerRadius(10)
    }
    
}

struct DayHistory_Previews: PreviewProvider {
    static let data = Step(date: "", count: 5458, userID: "", goal: 10000, username:"", group: 0)

    static var previews: some View {
        DayHistory(data: data)
            .environmentObject(AppViewModel())
            .environmentObject(UserViewModel())
        
    }
}
