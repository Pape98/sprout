//
//  DateStatus.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 25/08/2022.
//

import SwiftUI

struct DataStatus: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    
    var data: HealthData
    
    var date: String {
        let tokens: [String] = data.date.components(separatedBy: "-")
        return "\(tokens[0])/\(tokens[1])"
    }
    
    var goal: Int {
        if let goal = data.goal {
            return goal
        }
        return 0;
    }
    
    var image: String {
        
        let progress = (data.value / Double(goal)) * 100;
        
        if 0...24 ~= progress {
            return "faces/sad"
        } else if 25...50 ~= progress {
            return "faces/meh"
        } else if 51...75 ~= progress {
            return "faces/content"
        } else {
            return "faces/happy"
        }
        
        
    }
    
    
    var size: CGFloat = 75
    
    var body: some View {
        
        VStack {
            HStack(alignment: .center) {
                if let image = image {
                    Image(image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: size, height: size)
                }
                
                Text(data.textDisplay)
                    .foregroundColor(appViewModel.fontColor)
                
                Spacer()
                
                
                VStack(alignment: .trailing, spacing: 11) {
                    Text(data.date)
                        .bodyStyle(foregroundColor: .chalice, size: 13)
                    HStack(alignment: .center) {
                        
                        Image(systemName: "target")
                            .foregroundColor(.appleGreen)
                        
                        Text(String(goal))
                            .font(.system(size: 13))
                            .foregroundColor(.appleGreen)
                            .bodyStyle(foregroundColor: .appleGreen, size: 13)
                    }
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
        }
    }
}

struct DataStatus_Previews: PreviewProvider {
    
    static let step = Step(date: "07-14-2022", count: 4, userID: "555", username: "Pape Traore", group: 0)
    static var previews: some View {
        DataStatus(data: step)
            .environmentObject(AppViewModel())
        
    }
}
