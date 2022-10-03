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
    
    let date = Date().getFormattedDate(format: "MMMM dd")
    let twoColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    let rowOneGrid = [GridItem(.flexible()),GridItem(.fixed(125))]
    
    let today = Date()
    let userDefaults = UserDefaultsService.shared
    var TREE: String {
        let color = userDefaults.get(key: UserDefaultsKey.TREE_COLOR) ?? "cosmos"
        let tree = userDefaults.get(key: UserDefaultsKey.TREE) ?? "spiky-maple"
        return "\(color)-\(tree)"
    }
    
    let user = UserService.user
    
    var body: some View {
        
        // Content
        NavigationView {
            ZStack {
                MainBackground(edges: [.top])
                ScrollView(showsIndicators: false) {

                    VStack {

                        if let user = userViewModel.currentUser {
                            // Header
                            VStack {

                                if let settings = user.settings {
                                    CircledTree(option: "\(settings.treeColor)-\(addDash(settings.tree))",
                                                background: .appleGreen,
                                                size: 75)
                                } else {
                                    CircledTree(option: TREE, background: .seaGreen, size: 75)
                                        .padding(.top, 15)
                                }

                                VStack(spacing: 10) {
                                    Text("Hi, \(getFirstName(user.name))!")
                                        .headerStyle(foregroundColor: appViewModel.fontColor)

                                    Text(date)
                                        .bold()
                                        .bodyStyle(foregroundColor: appViewModel.fontColor)

                                }


                            }.padding(.bottom, 10)
                        }

                        // Card Row One


                        LazyVGrid(columns: rowOneGrid){


                            GardenInfoCard()


                            NavigationLink(destination: MyGarden()) {
                                ZStack {

                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.appleGreen)
                                        .opacity(0.7)
                                        .shadow(radius: 2)

                                    VStack(spacing:10) {
                                        Image("garden-icon")


                                        Text("View Garden")
                                            .font(.system(size: 15))
                                            .foregroundColor(Color.white)
                                            .bold()

                                    }
                                }
                                .frame(height: 141)
                            }
                        }


                        // Card Row Two

                        LazyVGrid(columns: twoColumnGrid) {

                            if isUserTrackingData(DataOptions.steps){
                                DashboardCard(icon: "figure.walk"){
                                    if let step = healthStoreViewModel.todayStepCount {
                                        CardInfo(value: "\(Int(step.count))", label: "Step(s)")
                                    } else {
                                        CardInfo(value: "0", label: "Step(s)")
                                    }
                                }
                            }


                            if isUserTrackingData(DataOptions.walkingRunningDistance){
                                DashboardCard(icon: "sportscourt.fill"){
                                    if let walkingRunning = healthStoreViewModel.todayWalkingRunningDistance {
                                        CardInfo(value: "\(Int(walkingRunning.distance))", label: "Mile(s)")
                                    } else {
                                        CardInfo(value: "0", label: "Mile(s)")
                                    }
                                }
                            }

                            if isUserTrackingData(DataOptions.workouts){
                                DashboardCard(icon: "clock"){
                                    if let workout = healthStoreViewModel.todayWorkout {
                                        CardInfo(value: "\(Int(workout.duration))", label: "Workout Minute(s)")
                                    } else {
                                        CardInfo(value: "0", label: "Workout Minute(s)")
                                    }
                                }
                            }

                            if isUserTrackingData(DataOptions.sleep){
                                DashboardCard(icon: "bed.double"){
                                    if let sleep = healthStoreViewModel.todaySleep {
                                        CardInfo(value: "\(Int(sleep.duration/60))", label: "Sleep Hour(s)")
                                    } else {
                                        CardInfo(value: "0", label: "Sleep Hour(s)")
                                    }
                                }
                            }
                        }

                        Spacer()

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
            .environmentObject(AppViewModel())
    }
}


