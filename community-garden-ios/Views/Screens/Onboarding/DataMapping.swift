//
//  DataMapping.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 20/06/2022.
//

import SwiftUI

struct Custom: View {
    
    var p: Point
    
    var body: some View {
        Circle()
            .fill(.green)
            .position(x: p.x, y: p.y)
            .frame(width: 10, height: 10)
    }
}

struct Point: Hashable {
    var x: CGFloat
    var y: CGFloat
}

struct DataMapping: View {
    
    let userDefaults: UserDefaultsService = UserDefaultsService.shared
    @EnvironmentObject var onboardingRouter: OnboardingRouter
    
    var selectedData: [String] {
        userDefaults.getArray(key: UserDefaultsKey.DATA) ?? ["Steps","Sleep"]
    }
    var treeType: String {
        userDefaults.getString(key:UserDefaultsKey.TREE) ?? "spiky-maple"
    }
    var treeColor: String {
        userDefaults.getString(key:UserDefaultsKey.TREE_COLOR) ?? "moss"
    }
    var flowerType: String {
        userDefaults.getString(key:UserDefaultsKey.FLOWER) ?? "joyful-clover"
    }
    var flowerColor: String {
        userDefaults.getString(key:UserDefaultsKey.FLOWER_COLOR) ?? "cosmos"
    }
    
    let columns = [GridItem(.flexible(), alignment: .top), GridItem(.flexible(), alignment: .top)]
    
    
    @State var mappedData: [String: String] = [:]
    @State var availableLabels: [String] = []
    @State var showingAlert = false
    
    
    var body: some View {
        
        VStack {
            PickerTitle(header: "I Want to See...", subheader: "To map data to elements in the scene, drag label to the image ")
            
            LazyVGrid(columns: columns, spacing: 20) {
                MetaphorCard(name: "\(treeColor)-\(treeType)", key: MappingKeys.TREE)
                MetaphorCard(name: "flowers/\(flowerColor)-\(flowerType)", key: MappingKeys.FLOWER)
            }.padding()
            
            //            Divider()
            //                .padding()
            
            Text("List of data")
                .bold()
                .bodyStyle()
            
            DataLabels()
            
            Spacer()
            
            BackNextButtons()
                .environmentObject(onboardingRouter)
        }
        .onAppear {
            self.availableLabels = selectedData
        }
        .alert("Must map all data 😊", isPresented: $showingAlert){
            Button("OK", role: .cancel){}
        }
    }
    
    @ViewBuilder
    func MetaphorCard(name: String, key: MappingKeys) -> some View {
        
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .opacity(0.7)
                
                Image(name)
                    .resizable()
                    .scaledToFit()
                    .padding()
            }
            .frame(maxWidth: 150, maxHeight: 150, alignment: .top)
            
            // Mapped Label
            
            if mappedData[key.rawValue] != nil {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.oliveGreen)
                        .opacity(0.8)
                        .frame(width: 150, height: 40)
                    Text(mappedData[key.rawValue]!)
                        .foregroundColor(.white)
                        .bold()
                }
                .padding(.top)
                .onTapGesture {
                    availableLabels.append(mappedData[key.rawValue]!)
                    mappedData.removeValue(forKey: key.rawValue)
                }
            }
            
        }
        .onDrop(of: [.url], isTargeted: .constant(false)) { providers in
            if let first = providers.first {
                let _ = first.loadObject(ofClass: URL.self) { value, error in
                    guard let url = value else  { return }
                    
                    // Check if card has already mapping
                    if let oldLabel = mappedData[key.rawValue] {
                        availableLabels.append(oldLabel)
                        mappedData.removeValue(forKey: key.rawValue)
                    }
                    
                    mappedData[key.rawValue] = url.absoluteString // "Tree":"Steps"
                    availableLabels = availableLabels.filter { $0 != url.absoluteString}
                    
                }
            }
            return false
        }
    }
    
    @ViewBuilder
    func DataLabels() -> some View {
        LazyVGrid(columns: columns) {
            ForEach(availableLabels, id: \.self) { data in
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.haze)
                        .cornerRadius(10)
                        .opacity(0.8)
                        .frame(width: 150, height: 40)
                    
                    Text(data)
                        .foregroundColor(.seaGreen)
                 
                }.onDrag {
                    return .init(contentsOf: URL(string: data))!
                }
            }
        }.padding()
    }
    
}

struct DataMapping_Previews: PreviewProvider {
    static var previews: some View {
        DataMapping()
            .environmentObject(OnboardingRouter())
            .background(Color.hawks)
    }
}
