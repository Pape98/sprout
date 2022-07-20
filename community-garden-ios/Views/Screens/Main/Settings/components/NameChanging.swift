//
//  NameChanging.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 7/19/22.
//

import SwiftUI

struct NameChanging: View {
    
    @State var gardenName: String = ""
    
    var body: some View {
        Form {
            Section( "Garden Name") {
                TextField("", text: $gardenName)
            }
        }
        .navigationTitle("Names")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("Done") {
                    print(gardenName)
                }
                
            }
        }
    }
}

struct NameChanging_Previews: PreviewProvider {
    static var previews: some View {
        NameChanging()
    }
}
