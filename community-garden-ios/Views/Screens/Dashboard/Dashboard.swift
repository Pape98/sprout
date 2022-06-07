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
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    let date = Date().getFormattedDate(format: "MMMM dd")
    
    var body: some View {
        
        ZStack {
            // Background Image
            Image("intro-bg")
                .resizable()
                .scaledToFill()
            
            // Content
            VStack {
                CircledItem(optionName: "oak", color: .seaGreen)
                    .padding(.top, 30)
                Text("Hi, Thomas!")
                    .headerStyle()
                Text("Are you excited today?")
                    .bodyStyle()
                
                
                // Card One
                ZStack(alignment: .leading) {
                    
                    // Steps
                    HStack {
                        VStack(alignment: .leading) {
                            Text("1247")
                                .bold()
                                .headerStyle()
                            Text("Steps")
                                .bold()
                                .bodyStyle()
                        }
                        
                        Spacer()
                        
                        // Buttons
                        HStack {
                            Image("droplet-icon")
                            Image("garden-icon")
                        }
                        
                    }
                    .padding(25)
                    .background {
                        ZStack (alignment: .leading) {
                            Rectangle()
                                .fill(.white)
                                .cornerRadius(10)
                                .opacity(0.8)
                            
                            Image("step-icon")
                        }
                    }
                }
                
                Spacer()
                
                Button("Sign Out"){
                    authViewModel.signOut()
                }
            }
            .padding()
            
            
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
        
        
        //        VStack(){
        //            Item(icon: "calendar", text: date, color: Color.green)
        //
        //            if let stepCount = userViewModel.currentUser.stepCount {
        //                Item(icon: "figure.walk", text: "\(String(stepCount.count)) Steps", color: Color.yellow)
        //            }
        //
        //            if let user = userViewModel.currentUser {
        //                Item(icon: "drop", text: "\(String(user.numDroplets)) Droplets", color: Color.blue)
        //            }
        //
        //            Spacer()
        //        }
        //        .navigationBarHidden(true)
    }
    
}


struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
            .environmentObject(UserViewModel())
            .environmentObject(AuthenticationViewModel())
    }
}
