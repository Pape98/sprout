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
                ScrollView {
                    
                    VStack {
                        
                        if let user = userViewModel.currentUser {
                            // Header
                            VStack {
                                
                                CircledTree(option: TREE, background: .seaGreen, size: 75)
                                    .padding(.top, 15)
                                
                                Text("Hi, \(getFirstName(user.name))!")
                                    .headerStyle()
                            }.padding(.bottom, 10)
                        }
                        
                        // Card Row One
                        if let user = userViewModel.currentUser {
                            GardenInfoCard(user: user)
                        }
                        
                        // Card Row Two
                        
                        LazyVGrid(columns: twoColumnGrid) {
                            
                            if let step = healthStoreViewModel.todayStepCount {
                                DashboardCard(icon: "figure.walk"){
                                    CardInfo(value: "\(Int(step.count))", label: "Step(s)")
                                }
                            }
                            
                            if let walkingRunning = healthStoreViewModel.todayWalkingRunningDistance {
                                DashboardCard(icon: "figure.walk"){
                                    CardInfo(value: "\(Int(walkingRunning.distance))", label: "Mile(s)")
                                }
                            }
                            
                            if let workout = healthStoreViewModel.todayWorkout {
                                DashboardCard(icon: "clock"){
                                    CardInfo(value: "\(Int(workout.duration))", label: "Workout Minute(s)")
                                }
                            }
                            
                            if let sleep = healthStoreViewModel.todaySleep {
                                DashboardCard(icon: "bed.double"){
                                    CardInfo(value: "\(Int(sleep.duration/60))", label: "Sleep Hour(s)")
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


