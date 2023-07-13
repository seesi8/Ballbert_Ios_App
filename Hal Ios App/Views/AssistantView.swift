import SwiftUI

struct AssistantView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    let assistant: Assistant
    let coreDM: DataController
    
    let populateAssistants: () -> Void
    
    @State var selection = 0


    
    var body: some View {
        NavigationStack {
            
            TabView(selection: $selection) {
                SkillAddView(ip: assistant.ipAddress ?? "")
                    .tabItem {
                        Image(systemName: "desktopcomputer.and.arrow.down")
                        Text("Add Skills")
                }.tag(0)
                SettingsView(assistant: assistant, coreDM: coreDM, populateAssistants: populateAssistants)
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                }.tag(1)
            }
            .navigationTitle(Text(selection == 1 ? "Modify \(assistant.name ?? "Assistant")" : "Manage Skills"))
        }
    }
    
}

