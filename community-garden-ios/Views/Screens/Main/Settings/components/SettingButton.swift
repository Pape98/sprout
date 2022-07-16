//
//  SettingButton.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 16/07/2022.
//

import SwiftUI

struct SettingButton: View {
    
    var label: String
    var image: String
    
    var body: some View {
        
        NavigationLink {
            Text(label)
        } label: {
            HStack{
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35)
                
                Text(label)
                Spacer()
            }
        }
    }
}

struct SettingButton_Previews: PreviewProvider {
    static var previews: some View {
        SettingButton(label: "Change tree color", image: "moss-tickle-beech")
    }
}
