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
            // Content
            ZStack {
                
                Image("sky-cloud-bg")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    // Heading
                    VStack {
                        Text("Choose your tree!")
                            .headerStyle()
                        Text("This will be used to track your steps")
                            .bodyStyle()
                    }
                    .padding(.vertical, 15)
                    
                    // Trees List
                    ForEach(treeOptions, id: \.self){ tree in
                        PickerCard(optionName: tree)
                            .border(Color.appleGreen, width: selectedTree == tree ? 6 : 0)
                            .cornerRadius(10)
                            .onTapGesture {
                                selectedTree = tree
                            }
                        
                    }
                    
                    // Button
                    TreePickerNextButton(selectedTree: selectedTree)
                    
                    Spacer()
                    
                }
                .padding(30)
           
            }
            .navigationBarHidden(true)
        }
    }
}

struct TreePickerNextButton: View {
    
    var selectedTree: String
    
    var body: some View {
        NavigationLink(destination: Dashboard()) {
            Text("Next")
                .bold()
        }
        .disabled(selectedTree == "")
        .opacity(selectedTree == "" ? 0.5 : 1)
        .buttonStyle(ActionButtonStyle())
        .frame(maxWidth: 250)
        .padding(.top, 40)
    }
}

struct TreePicker_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TreePicker()
        }
    }
}
