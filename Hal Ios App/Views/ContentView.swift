//
//  ContentView.swift
//  Hal Ios App
//
//  Created by Sam Liebert on 6/27/23.
//
import CoreData
import SwiftUI

struct AssistantInfo : Hashable {
    var ipAddress: String
    var name: String
    var location: String
    var selectedIcon: String
}

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme

    @State private var assistants: [Assistant] = [Assistant]()
    @State private var refreshID = UUID()

    let coreDM: DataController
   
    private func populateAssistants() {
        assistants = coreDM.getAllAssistants()
        refreshID = UUID()
    }
    
    @State private var connectionStatus: [String: Bool] = [:]

    private func checkAssistantConnection(_ assistant: Assistant) {
        guard let ipAddress = assistant.ipAddress else {
            return
        }
        
        checkConnection(ip: ipAddress) { isConnected in
            DispatchQueue.main.async {
                connectionStatus[ipAddress] = isConnected
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(assistants, id: \.self) { assistant in
                    NavigationLink(destination: AssistantView(
                        assistant: assistant,
                        coreDM: coreDM,
                        populateAssistants: populateAssistants
                    )) {
                        HStack {
                            Image(systemName: assistant.selectedIcon ?? "hand.thumbsdown.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 45, height: 45)
                            
                            VStack(alignment: .leading) {
                                Text(assistant.name ?? "Error")
                                Text(assistant.ipAddress ?? "127.0.0.1")
                                    .font(.footnote)
                                    .foregroundColor(connectionStatus[assistant.ipAddress ?? ""] == true ? Color.green : Color.red)
                            }
                            
                            Spacer()
                        }
                    }
                    .onAppear {
                        checkAssistantConnection(assistant)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        coreDM.deleteAssistant(assistant: assistants[index])
                    }
                    populateAssistants()
                }
            }
            .navigationTitle(Text("Add Assistants"))
            .id(refreshID)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    AssistantAdder(coreDM: coreDM, populateAssistants: populateAssistants)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
        }
        .onAppear(perform: {
            populateAssistants()
        })
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(coreDM: DataController())
            .previewInterfaceOrientation(.portrait)



    }
}
