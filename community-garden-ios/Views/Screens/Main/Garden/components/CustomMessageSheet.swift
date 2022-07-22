//
//  CustomMessageSheet.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 21/07/2022.
//

import SwiftUI


struct CustomMessageSheet: View {
    
    @EnvironmentObject var messagesViewModel: MessagesViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedColor: String = "grenadier"
    @State private var text = "Type your message here 😊"
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack {
                    MainBackground(image: "sky-cloud-bg",edges: [.bottom])
                    
                    VStack() {
                        
                        Text("Preview")
                            .padding()
                        
                        ZStack {
                            
                            Text(text)
                                .frame(alignment: .center)
                                .padding()
                                .multilineTextAlignment(.leading)
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(selectedColor))
                                        .opacity(0.8)
                                        .frame(width: geometry.size.width * 0.9)
                                }
                                .padding()
                        }
                        
                        Form {
                            Section() {
                                
                                TextEditor(text: $text)
                                
                                List {
                                    Picker("Color", selection: $selectedColor) {
                                        ForEach(Constants.colors, id: \.self){ color in
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color(color))
                                                .tag(color)
                                                .frame(width: 150)
                                                .opacity(0.8)
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                    
                }
                .navigationTitle("Custom Message")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    Button("Add"){
                        messagesViewModel.addOption(text: text, color: selectedColor)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct CustomMessageSheet_Previews: PreviewProvider {
    
    @State static var text: String = "Type your message here 😊"
    static var previews: some View {
        CustomMessageSheet()
    }
}
