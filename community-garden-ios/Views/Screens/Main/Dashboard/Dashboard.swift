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
    @EnvironmentObject var healthStoreViewModel: HealthStoreViewModel
    
    let date = Date().getFormattedDate(format: "MMMM dd")
    let twoColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    let today = Date()
    let userDefaults = UserDefaultsService.shared
    var TREE: String {
        let color = userDefaults.get(key: UserDefaultsKey.TREE_COLOR) ?? "cosmos"
        let tree = userDefaults.get(key: UserDefaultsKey.TREE) ?? "spiky-maple"
        return "\(color)-\(tree)"
    }
    
    var body: some View {
        // Content
        NavigationView {
            ZStack {
                
                MainBackground()
                ScrollView(showsIndicators: false) {
                    
                    VStack {
                        
                        if let user = userViewModel.currentUser {
                            // Header
                            VStack {
                                
                                CircledTree(option: TREE, background: .seaGreen, size: 75)
                                    .padding(.top, 15)
                                
                                VStack(spacing: 10) {
                                    Text("Hi, \(getFirstName(user.name))!")
                                        .headerStyle()
                                    
                                    
                                    Text(date)
                                        .bold()
                                        .bodyStyle()
                                }
                                
                                
                            }.padding(.bottom, 10)
                        }
                        
                        // Card Row One
                        if let user = userViewModel.currentUser {
                            GardenInfoCard(user: user)
                        }
                        
                        // Card Row Two
                        
                        LazyVGrid(columns: twoColumnGrid) {
                            
                            
                            DashboardCard(icon: "figure.walk"){
                                if let step = healthStoreViewModel.todayStepCount {
                                    CardInfo(value: "\(Int(step.count))", label: "Step(s)")
                                } else {
                                    CardInfo(value: "0", label: "Step(s)")
                                }
                            }
                            
                            
                            DashboardCard(icon: "figure.walk"){
                                if let walkingRunning = healthStoreViewModel.todayWalkingRunningDistance {
                                    CardInfo(value: "\(Int(walkingRunning.distance))", label: "Mile(s)")
                                } else {
                                    CardInfo(value: "0", label: "Mile(s)")
                                }
                            }
                            
                            DashboardCard(icon: "clock"){
                                if let workout = healthStoreViewModel.todayWorkout {
                                    CardInfo(value: "\(Int(workout.duration))", label: "Workout Minute(s)")
                                } else {
                                    CardInfo(value: "0", label: "Workout Minute(s)")
                                }
                            }
                            
                            
                            DashboardCard(icon: "bed.double"){
                                if let sleep = healthStoreViewModel.todaySleep {
                                    CardInfo(value: "\(Int(sleep.duration/60))", label: "Sleep Hour(s)")
                                } else {
                                    CardInfo(value: "0", label: "Sleep Hour(s)")
                                }
                            }
                            
                        }
                        
                        Spacer()
                        
                        Button("Sign Out"){
                            authViewModel.signOut()
                        }.padding()
                        
                    }
                }
                .navigationBarHidden(true)
                .padding(.horizontal, 25)
                
            }
        }
        
    }
    
    @ViewBuilder
    func CardInfo(value: String, label: String = "") -> some View {
        VStack {
            Text(value)
                .headerStyle()
                .font(.title3)
            Text(label)
                .bold()
                .bodyStyle()
        }
    }
    
}
struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
            .environmentObject(UserViewModel())
            .environmentObject(AuthenticationViewModel())
            .environmentObject(HealthStoreViewModel())
    }
}


