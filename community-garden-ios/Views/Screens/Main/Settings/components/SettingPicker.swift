//
//  SettingsPicker.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 16/07/2022.
//

import SwiftUI

struct SettingPicker: View {
    
    @State var selection = "spiky-maple"
    @State var showAlert = false
    var title: String
    var prefix: String = ""
    var data: [String]
    var mode: SettingsMode
    
    var body: some View {
        VStack {
            List {
                ForEach(data, id: \.self){ item in
                    Row(label: formatItemName(item).lowercased(), image: "\(prefix)-\(item)")
                }
            }
            .alert(isPresented: $showAlert){
                Alert(title: Text(title),
                      message: Text("\(title) has been updated to \(selection) 😊"),
                      dismissButton: .default(Text("Got it!")))
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
    
    @ViewBuilder
    func Row(label: String, image: String) -> some View {
        
        var imageName: String {
            switch mode {
            case SettingsMode.flowerColor:
                return "petals/\(label)-abyss-sage"
            case .treeColor:
                return "\(label)-spiky-maple"
            default:
                return image
            }
        }
        
        return HStack {
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding()
            
            Text(label)
            Spacer()
            
            if selection == label {
                Image(systemName: "checkmark")
                    .foregroundColor(.appleGreen)
                    .padding(.trailing)
            }
        }
        .onTapGesture {
            selection = label
            showAlert = true
        }
    }
}


struct SettingPicker_Previews: PreviewProvider {
    static var trees = Constants.trees
    static var colors = Constants.colors
    static var previews: some View {
        SettingPicker(title: "Tree Type", prefix: "moss", data: colors, mode: SettingsMode.treeType)
    }
}
