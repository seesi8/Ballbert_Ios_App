import SwiftUI

struct AssistantView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    let assistant: Assistant
    let coreDM: DataController
    
    let populateAssistants: () -> Void

    
    var body: some View {
        VStack {
            
            TabView {
                SkillAddView(ip: assistant.ipAddress ?? "")
                    .tabItem {
                        Image(systemName: "desktopcomputer.and.arrow.down")
                        Text("Add Skills")
                }
                SettingsView(assistant: assistant, coreDM: coreDM, populateAssistants: populateAssistants)
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    .navigationTitle("Settings")

                }
            }
        }
    }
    
}

