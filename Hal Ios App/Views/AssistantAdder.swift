//
//  AssistantAdder.swift
//  Hal Ios App
//
//  Created by Sam Liebert on 6/28/23.
//

import SwiftUI

struct AssistantAdder: View {
    @State private var showAddSheet = false
    @State private var ipAddress = ""
    @State private var selectedIcon: String = ""
    @State private var name: String = ""
    @State private var location: String = ""
    @State private var showIconPicker: Bool = false
    
    let coreDM: DataController
    let populateAssistants: () -> Void

        
    func validateFields() -> Bool {
        return !ipAddress.isEmpty && !name.isEmpty && !location.isEmpty && !selectedIcon.isEmpty
    }
    
    func saveDeviceSettings() {
        coreDM.saveAssistant(ipAddress: ipAddress, name: name, location: location, selectedIcon: selectedIcon)
        populateAssistants()
    }
    
    
    
    var body: some View {
        Button {
            showAddSheet.toggle()
        } label: {
            Image(systemName: "plus.circle")
                .resizable()
        }
        .sheet(isPresented: $showAddSheet) {
            Form {
                Section(header: Text("Device Information")) {
                    TextField("IP Address", text: $ipAddress)
                    TextField("Name", text: $name)
                    TextField("Location", text: $location)
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
                        showAddSheet.toggle()
                    }
                    .disabled(!validateFields())
                }
            }
            .navigationTitle("Device Settings")
        }
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
