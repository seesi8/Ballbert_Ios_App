//
//  AssistantAdder.swift
//  Hal Ios App
//
//  Created by Sam Liebert on 6/28/23.
//

import SwiftUI

struct AssistantAdder: View {
    @State private var ipAddress = ""
    @State private var selectedIcon = ""
    @State private var name = ""
    @State private var location = ""
    @State private var openai = ""
    @State private var porqupine = ""
    @State private var huggingface = ""
    @State private var llm = ""
    
    let coreDM: DataController
    let populateAssistants: () -> Void

    
    
    func saveDeviceSettings() {
        print("saving")
        coreDM.saveAssistant(ipAddress: ipAddress, name: name, location: location, selectedIcon: selectedIcon)
        print("saved")
        populateAssistants()
    }
    
    
    
    var body: some View {
        SettingsSheetView(ipAddress: $ipAddress, selectedIcon: $selectedIcon, name: $name, location: $location, openai: $openai, llm: $llm, huggingface: $huggingface, porqupine: $porqupine, saveDeviceSettings: saveDeviceSettings)
        .navigationTitle("Device Settings")
    }
}



struct AssistantAdder_Previews: PreviewProvider {
    static var previews: some View {
        AssistantAdder(
            coreDM: DataController(),
            populateAssistants: { () -> Void in }
        )
    }
}
