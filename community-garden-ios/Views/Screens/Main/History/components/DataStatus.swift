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
    
    var size: CGFloat = 75
    
    var body: some View {
        
        VStack {
            HStack(alignment: .center) {
                
                Circle()
                    .fill(Color.appleGreen)
                    .frame(width: size, height: size)
                
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
