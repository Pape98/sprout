//
//  TreePicker.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 6/6/22.
//

import SwiftUI


struct TreePicker: View {
    
    @State private var selectedTree = ""
    let treeOptions = Constants.trees
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Image
                Image("sky-bg")
                    .resizable()
                    .scaledToFill()
                
                // Content
                VStack(spacing: 20) {
                    
                    // Heading
                    VStack {
                        Text("Choose your tree!")
                            .font(.largeTitle)
                            .foregroundColor(.seaGreen)
                            .bold()
                        Text("This will be used to track your steps")
                            .foregroundColor(.seaGreen)
                            .opacity(0.66)
                    }
                    .padding(.vertical, 15)
                    
                    // Trees List
                    ForEach(treeOptions, id: \.self){ tree in
                        PickerCardView(optionName: tree)
                            .border(Color.appleGreen, width: selectedTree == tree ? 6 : 0)
                            .cornerRadius(10)
                            .onTapGesture {
                                selectedTree = tree
                            }
                    }
                    
                    
                    // Button
                    NavigationLink(destination: Dashboard()) {
                        Text("Next")
                            .bold()
                    }
                    .disabled(selectedTree == "")
                    .opacity(selectedTree == "" ? 0.5 : 1)
                    .buttonStyle(ActionButtonStyle())
                    .frame(maxWidth: 250)
                    .padding(.top, 40)
                    
                    Spacer()
                    
                }
                .padding(30)
                
            }
            .ignoresSafeArea()
        }
    }
}

struct TreePicker_Previews: PreviewProvider {
    static var previews: some View {
        TreePicker()
    }
}
