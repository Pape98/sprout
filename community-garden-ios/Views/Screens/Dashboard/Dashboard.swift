//
//  Dashboard.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 5/22/22.
//

import SwiftUI

struct Item: View {
    var icon: String
    var text: String
    var color: Color
    
    let width = UIScreen.main.bounds.width - 20
    
    var body: some View {
        HStack{
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(30)
            Spacer()
            Text(text)
                .padding()
                .font(.title)
        }.frame(width: width, height: 120)
            .background(color)
            .cornerRadius(15)
        
    }
}

struct Dashboard: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    let date = Date().getFormattedDate(format: "MMMM dd")
    
    var body: some View {
        
        NavigationView {
            VStack(){
                Item(icon: "calendar", text: date, color: Color.green)
                
                if let stepCount = userViewModel.currentUser.stepCount {
                    Item(icon: "figure.walk", text: "\(String(stepCount.count)) Steps", color: Color.yellow)
                }
                
                if let user = userViewModel.currentUser {
                    Item(icon: "drop", text: "\(String(user.numDroplets)) Droplets", color: Color.blue)
                }
                
                Spacer()
            }
            .navigationBarTitle(Text("Dashboard"))
        }
        
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
    }
}
