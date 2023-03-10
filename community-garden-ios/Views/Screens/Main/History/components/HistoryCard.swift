//
//  HistoryCard.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 10/31/22.
//

import SwiftUI

struct HistoryCard: View {
    
    var data: HealthData
    
    var image: String {
        
        let progress = (data.value / Double(data.goal!)) * 100;
        
        if 0...24 ~= progress {
            return "faces/sad"
        } else if 25...50 ~= progress {
            return "faces/meh"
        } else if 51...99 ~= progress {
            return "faces/content"
        } else {
            return "faces/happy"
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.white.opacity(0.6)
                
                VStack(spacing: 10) {
                    
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Image(systemName: "target")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 13, height: 13)
                                .foregroundColor(.appleGreen)
                            
                            Text("\(data.goalDisplay)")
                                .bodyStyle(size: 12)
                            
                        }
                        
                        HStack {
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 13, height: 13)
                                .foregroundColor(.seaGreen)
                            
                            Text("\(data.textDisplay)")
                                .bodyStyle(size: 12)
                        }
                    }
                    
                }
                .padding()
            }
            
            .cornerRadius(10)
        }
    }
}

struct HistoryCard_Previews: PreviewProvider {
    static let data = Step(date: "", count: 5458, userID: "", goal: 10000, username:"", group: 0)
    static var previews: some View {
        ZStack {
            Color.hawks
            HistoryCard(data: data)
        }
    }
}
