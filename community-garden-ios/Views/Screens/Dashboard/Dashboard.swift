//
//  Dashboard.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 5/22/22.
//

import SwiftUI

struct Dashboard: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    let date = Date().getFormattedDate(format: "MMMM dd")
    let twoColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    
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
                
                
                // Card Row One
                GardenInfoCard()
                
                // Card Row Two
                
                GeometryReader { geometry in
                    ScrollView {
                        LazyVGrid(columns: twoColumnGrid) {
                            
                            DashboardCard(width: geometry.size.width / 2, icon: "calendar-icon"){
                                VStack {
                                    Text("23")
                                        .headerStyle()
                                    Text("May")
                                        .bold()
                                        .bodyStyle()
                                }
                            }
                            
                            DashboardCard(width: geometry.size.width / 2, icon: "temp-icon"){
                                    Text("64°")
                                        .headerStyle()
                            }
                            
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
        
        
    }
    
}


struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
            .environmentObject(UserViewModel())
            .environmentObject(AuthenticationViewModel())
    }
}

struct IconButton: View {
    var icon: String
    var text: String
    
    var body: some View {
        VStack() {
            Image(icon)
            Text(text)
                .font(.system(size: 15))
                .foregroundColor(.seaGreen)
        }.frame(maxWidth: .infinity, alignment: .trailing)
    }
    
}

struct GardenInfoCard: View {
    
    var body: some View {
        
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
                HStack(spacing: 10) {
                    IconButton(icon: "droplet-icon", text: "5 droplets")
                    IconButton(icon: "garden-icon", text: "Your Garden")
                    
                }
                
            }
            .padding(25)
            .background {
                ZStack (alignment: .leading) {
                    Rectangle()
                        .fill(.white)
                        .cornerRadius(10)
                        .opacity(0.9)
                    
                    Image("step-icon")
                }
            }
        }
    }
}

struct DashboardCard<Content: View>: View {
    
    var width: CGFloat
    var icon: String
    @ViewBuilder var content: Content
    
    var body: some View {
        
        content
            .frame(width: width, height: 60)
            .padding(.vertical, 20)
            .background{
                ZStack (alignment: .topLeading) {
                    Rectangle()
                        .fill(.white)
                        .cornerRadius(10)
                        .opacity(0.9)
                    
                    Image(icon)
                        .padding(10)
                }
                
                
            }
    }
}
