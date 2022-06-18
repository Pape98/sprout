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
    let today = Date()
    
    let defaultTree = UserDefaultsService.shared.getString(key: UserDefaultsKey.TREE)
    
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
                            CircledTree(option: defaultTree!, background: .seaGreen)
                                .padding(.top, 30)
                        } else {
                            CircledTree(option: "moss-spiky-maple", background: .seaGreen)
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
                                    Text(today.getFormattedDate(format: "dd"))
                                        .headerStyle()
                                    Text(today.getFormattedDate(format: "MMM"))
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


