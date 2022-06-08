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
    
    let defaultTree = UserDefaultsService.shared.getString(key: SettingsKey.TREE)
    
    var body: some View {
        // Content
        ZStack {
            
            Image("intro-bg")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                
                if let user = userViewModel.currentUser {
                    // Header
                    VStack {
                        if  (defaultTree != nil)  {
                            CircledItem(optionName: defaultTree!, color: .seaGreen)
                                .padding(.top, 30)
                        } else {
                            CircledItem(optionName: "oak", color: .seaGreen)
                                .padding(.top, 30)
                        }
                        
                        Text("Hi, \(getFirstName(user.name))!")
                            .headerStyle()
                        Text("Are you excited today?")
                            .bodyStyle()
                    }.padding(.bottom, 25)
                }
                
                ScrollView {
                    // Card Row One
                    if let user = userViewModel.currentUser {
                        GardenInfoCard(user: user)
                    }
                    
                    // Card Row Two
                    GeometryReader { geometry in
                        
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
            }.padding()
        }.navigationBarHidden(true)
    }
    
}





struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
            .environmentObject(UserViewModel())
            .environmentObject(AuthenticationViewModel())
    }
}


