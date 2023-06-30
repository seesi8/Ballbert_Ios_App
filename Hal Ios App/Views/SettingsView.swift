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
    }
    
    func populateFields(){
        ipAddress = assistant.ipAddress ?? "ip"
        selectedIcon = assistant.selectedIcon ?? "si"
        name = assistant.name ?? "nm"
        location = assistant.location ?? "lc"
    }
    
    var body: some View {
        Form {
            Section(header: Text("Device Information")) {
                //V-stack is there so that they are updated programaticly i have no idea why it is needed but sourse here: https://codecrew.codewithchris.com/t/textfield-doesnt-show-text-until-its-selected-new-xcode/15027
                VStack{
                    TextField("IP Address", text: $ipAddress)
                }
                VStack{
                    TextField("Name", text: $name)
                }
                VStack{
                    TextField("Location", text: $location)
                }
                
            }
            Section {
                HStack {
                    Text("Select Icon")
                        .foregroundColor(.blue)
                    Spacer()
                    Text(selectedIcon)
                        .foregroundColor(.gray)
                    Image(systemName: showIconPicker ? "chevron.up" : "chevron.down")
                        .foregroundColor(.blue)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        showIconPicker.toggle()
                    }
                }
                if showIconPicker {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(icons, id: \.self) { icon in
                            Button(action: {
                                withAnimation {
                                    selectedIcon = icon
                                    showIconPicker.toggle()
                                }
                            }) {
                                Image(systemName: icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                    .padding(8)
                                    .background(selectedIcon == icon ? Color.blue.opacity(0.5) : Color.clear)
                                    .cornerRadius(10)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.top, 8)
                    .transition(.opacity)
                }
            }
            Section {
                Button("Save") {
                    saveDeviceSettings()
                    self.presentationMode.wrappedValue.dismiss()

                }
                .disabled(!validateFields())                }
        }
        .onAppear(){
            populateFields()
        }
    }
}
