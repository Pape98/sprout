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
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var gardenViewModel: GardenViewModel
    @EnvironmentObject var communityViewModel: CommunityViewModel
    
    let date = Date().getFormattedDate(format: "MMMM dd")
    let twoColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    let rowOneGrid = [GridItem(.flexible()),GridItem(.fixed(125))]
    
    let today = Date()
    let userDefaults = UserDefaultsService.shared
    var defaultTree: String = "cosmos-spiky-maple"
     
    
    
    let user = UserService.shared.user
    
    var body: some View {
        
        // Content
        NavigationView {
            GeometryReader { geo in
                ZStack {
                    MainBackground(edges: [.top])
                    
                    ScrollView(showsIndicators: false) {
                        
                        VStack {
                            
                            if let user = userViewModel.currentUser {
                                // Header
                                VStack(spacing: 2) {
                                    
                                    if let settings = user.settings {
                                        CircledTree(option: "\(settings.treeColor)-\(addDash(settings.tree))",
                                                    background: .appleGreen,
                                                    size: 75)
                                    } else {
                                        CircledTree(option: defaultTree, background: .seaGreen, size: 75)
                                            .padding(.top, 15)
                                    }
                                    
                                    VStack(spacing: 0) {
                                        Text("Hi, \(getFirstName(user.name))!")
                                            .headerStyle(foregroundColor: appViewModel.fontColor)
                                        
                                        Text(date)
                                            .bold()
                                            .bodyStyle(foregroundColor: appViewModel.fontColor)
                                        
                                    }
                                    
                                    
                                }.padding(.bottom, 10)
                            }
                            
                            // Card Row 1
                            
                            LazyVGrid(columns: rowOneGrid){
                                
                                
                                GardenInfoCard()
                                
                                
                                NavigationLink(destination: MyGarden()) {
                                    ZStack {
                                        
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.appleGreen)
                                      
                                        
                                        VStack(spacing:10) {
                                            Image("garden-icon")
                                                .shadow(color: .chalice, radius: 5, x: 0, y: 8)
                                            
                                            
                                            Text("View Garden")
                                                .bodyStyle(foregroundColor: Color.white)
                                                .opacity(1)
                                            
                                        }
                                    }
                                    .frame(height: 141)
                                }
                            }
                            
                            // Card Row 2
                            LazyVGrid(columns: twoColumnGrid) {
                                
                                if isUserTrackingData(DataOptions.steps){
                                    DashboardCard(icon: "figure.walk"){
                                        if let step = healthStoreViewModel.todayStepCount {
                                            CardInfo(value: step.count, label: "Step(s)", goal: step.goal)
                                        } else {
                                            CardInfo(value: 0, label: "Step(s)")
                                        }
                                    }
                                }
                                
                                
                                if isUserTrackingData(DataOptions.walkingRunningDistance){
                                    DashboardCard(icon: "sportscourt.fill"){
                                        if let walkingRunning = healthStoreViewModel.todayWalkingRunningDistance {
                                            CardInfo(value: walkingRunning.distance, label: "Mile(s)", goal: walkingRunning.goal)
                                        } else {
                                            CardInfo(value: 0, label: "Mile(s)")
                                        }
                                    }
                                }
                                
                                if isUserTrackingData(DataOptions.workouts){
                                    DashboardCard(icon: "bicycle"){
                                        if let workout = healthStoreViewModel.todayWorkout {
                                            CardInfo(value: workout.duration, label: "Workout Minute(s)", goal: workout.goal)
                                        } else {
                                            CardInfo(value: 0, label: "Workout Minute(s)")
                                        }
                                    }
                                }
                                
                                if isUserTrackingData(DataOptions.sleep){
                                    DashboardCard(icon: "bed.double"){
                                        if let sleep = healthStoreViewModel.todaySleep {
                                            CardInfo(value: sleep.duration/60, label: "Sleep Hour(s)", goal: (sleep.goal ?? 0)/60)
                                        } else {
                                            CardInfo(value: 0, label: "Sleep Hour(s)")
                                        }
                                    }
                                }
                            }
                            
                            // Card Row 3
                            if appViewModel.isSocialConfig {
                                GoalsMetCard(goals: communityViewModel.goalsStat)
                                    .onAppear {
                                        communityViewModel.getGoalCompletions()
                                        communityViewModel.fetchGroupMembers()
                                    }
                            }
                            
                            EmptyView()
                            
                            Spacer()
                            
                        }
                        .frame(height: geo.size.height * 1.25)
                    }
                    .navigationBarHidden(true)
                    .padding(.horizontal, 25)
                }
                .onAppear {
                    appViewModel.setIntroBackground()
                }
            }
        }
    }
    
    @ViewBuilder
    func CardInfo(value: Double, label: String = "", goal: Int? = nil) -> some View {
        VStack(spacing: 3) {
            
            if label == "Mile(s)" {
                Text(String(format: "%.2f", value) )
                    .headerStyle()
                
            } else {
                Text(String(Int(value)))
                    .headerStyle()
            
            }
            
            Text(label)
                .bold()
                .bodyStyle()
            
            if goal != nil && goal! > 0 {
                ProgressView(value: value/Double(goal!) <= 1 ? value/Double(goal!) : 1 )
                    .padding(.horizontal)
            } else {
                ProgressView(value: 0)
                    .padding(.horizontal)
            }
        }
        .padding()
    }
    
}
struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
            .environmentObject(UserViewModel())
            .environmentObject(AuthenticationViewModel())
            .environmentObject(HealthStoreViewModel())
            .environmentObject(AppViewModel())
            .environmentObject(CommunityViewModel())
            .environmentObject(GardenViewModel())
    }
}


