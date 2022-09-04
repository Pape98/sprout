//
//  DateStatus.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 25/08/2022.
//

import SwiftUI

struct DataStatus: View {
    
    var data: HealthData
    
    var date: String {
        let tokens: [String] = data.date.components(separatedBy: "-")
        return "\(tokens[0])/\(tokens[1])"
    }
    
    var goal: Int? {
        if let settings = UserService.user.settings {
            switch data.label {
            case "step":
                return settings.stepsGoal
            case "walkingRunning":
                return settings.walkingRunningGoal
            case "sleep":
                return settings.sleepGoal
            case "workout":
                return settings.workoutsGoal
            default:
                return 0
            }
        }
        
        return 0;
    }
    
    var image: String? {
        if let goal = goal {
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
        
        return nil
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
                    .font(.system(size: 15))
                
                Spacer()

                
                Text(data.date)
                    .font(.system(size: 13))
                    .foregroundColor(.chalice)
                    .bold()
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
        }
    }
}

struct DataStatus_Previews: PreviewProvider {
    
    static let step = Step(date: "07-14-2022", count: 4, userID: "555")
    static var previews: some View {
        DataStatus(data: step)
        
    }
}
