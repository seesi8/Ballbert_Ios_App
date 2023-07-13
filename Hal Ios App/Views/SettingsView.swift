//
//  SettingsView.swift
//  Hal Ios App
//
//  Created by Sam Liebert on 6/28/23.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var ipAddress = ""
    @State private var selectedIcon: String = ""
    @State private var name: String = ""
    @State private var location: String = ""
    @State private var showIconPicker: Bool = false
    @State private var openai = ""
    @State private var porqupine = ""
    @State private var llm = ""
    
    let assistant: Assistant
    let coreDM: DataController
    
    let populateAssistants: () -> Void
    
    func validateFields() -> Bool {
        return !ipAddress.isEmpty && !name.isEmpty && !location.isEmpty && !selectedIcon.isEmpty
    }
    
    func saveDeviceSettings() {
        assistant.ipAddress = ipAddress
        assistant.name = name
        assistant.location = location
        assistant.selectedIcon = selectedIcon
        coreDM.updateAssistant()
        populateAssistants()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func populateFields(){
        ipAddress = assistant.ipAddress ?? "ip"
        selectedIcon = assistant.selectedIcon ?? "si"
        name = assistant.name ?? "nm"
        location = assistant.location ?? "lc"
        
        getEnviromentVariables(ip: ipAddress, key: "OPENAI_API_KEY") { api_key, err in
            if api_key != nil{
                openai = api_key ?? ""
            }
        }
        getEnviromentVariables(ip: ipAddress, key: "PORQUPINE_API_KEY") { api_key, err in
            if api_key != nil{
                porqupine = api_key ?? ""
            }

        }
        getEnviromentVariables(ip: ipAddress, key: "LLM") { theLLM, err in
            if theLLM != nil{
                llm = theLLM ?? ""
            }

        }

    }
    
    var body: some View {
        SettingsSheetView(ipAddress: $ipAddress, selectedIcon: $selectedIcon, name: $name, location: $location, openai: $openai, llm: $llm, porqupine: $porqupine, saveDeviceSettings: saveDeviceSettings)
            .onAppear(){
                populateFields()
            }
    }
}
