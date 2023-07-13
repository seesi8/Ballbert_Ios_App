//
//  SettingsSheetView.swift
//  Hal Ios App
//
//  Created by Sam Liebert on 7/11/23.
//

import SwiftUI

struct SettingsSheetView: View {
    @Binding var ipAddress: String
    @Binding var selectedIcon : String
    @Binding var name : String
    @Binding var location : String
    @Binding var openai: String
    @Binding var llm: String
    @State var isShowing = false
    @Binding var porqupine: String
    @State private var isApiKeyValid = false
    @State private var isPorcupineKeyValid = false
    @State private var showIconPicker: Bool = false
    @State private var llms: [String] = [String]()
    @State private var selectedFile: URL?
    @State private var fileValid = false
    
    func validateFile() {
        guard let fileURL = selectedFile else {
            print("No file selected")
            return
        }
        
        APIManager.validateFile(ip: ipAddress, fileURL: fileURL) { isValid in
            self.fileValid = isValid
        }
    }
    
    
    var saveDeviceSettings: () -> Void

    func validateOpenaiApiKey() {
        checkOpenaiApiKey(ip: ipAddress, key: openai) { isValid in
            DispatchQueue.main.async {
                isApiKeyValid = isValid ?? false
            }
        }
    }
    
    func validateFields() -> Bool {
        return !$ipAddress.wrappedValue.isEmpty && !$name.wrappedValue.isEmpty && !$location.wrappedValue.isEmpty && !$selectedIcon.wrappedValue.isEmpty && !$llm.wrappedValue.isEmpty && isApiKeyValid && isPorcupineKeyValid && fileValid
    }
    
    func validatePorqupineApiKey() {
        checkPorcupineApiKey(ip: ipAddress, key: porqupine) { isValid in
            DispatchQueue.main.async {
                isPorcupineKeyValid = isValid ?? false
            }
        }
    }
    
    func populateLLMS(){
        getLLMS(ip: ipAddress, api_key: openai) { models,_ in
            
            if models != nil{
                if llms == []{
                    llm = models?[0] ?? ""
                }
                llms = models ?? []
            }
        
        }
    }
    

    
    
    var body: some View {
        Form {
            Section(header: Text("Device Information")) {
                TextField("IP Address", text: $ipAddress)
                    .onChange(of: ipAddress) { _ in
                        getEnviromentVariables(ip: ipAddress, key: "GOOGLE_APPLICATION_CREDENTIALS") { google, err in
                            if google != nil{
                                fileValid = true
                            }
                        }
                    }
                TextField("Name", text: $name)
                TextField("Location", text: $location)
            }
            Section(header: Text("Device Settings")) {
                TextField("Open Ai API Key", text: $openai)
                    .onChange(of: openai) { _ in
                        // Validate the API key whenever it changes
                        validateOpenaiApiKey()
                        populateLLMS()
                    }
                    .foregroundColor(isApiKeyValid ? .green : .red) // Change text color based on validation result

                TextField("Porqupine API Key", text: $porqupine)
                    .onChange(of: porqupine) { _ in
                        // Validate the API key whenever it changes
                        validatePorqupineApiKey()
                    }
                    .foregroundColor(isPorcupineKeyValid ? .green : .red) // Change text color based on validation result
                Picker("LLM", selection: $llm) {
                    ForEach(llms, id: \.self) { model in
                        Text(model)
                    }
                }
            }
            Section {
                HStack {
                    Text("Select Icon")
                        .foregroundColor(.blue)
                    Spacer()
                    Text($selectedIcon.wrappedValue)
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
                                    $selectedIcon.wrappedValue = icon
                                    showIconPicker.toggle()
                                }
                            }) {
                                Image(systemName: icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                    .padding(8)
                                    .background($selectedIcon.wrappedValue == icon ? Color.blue.opacity(0.5) : Color.clear)
                                    .cornerRadius(10)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.top, 8)
                    .transition(.opacity)
                }
                VStack{
                    Button {
                        isShowing.toggle()
                    } label: {
                        Text("Upload Google Cloud Credentials")
                            .foregroundColor(fileValid ? Color.green : Color.red)
                    }
                }
                .fileImporter(isPresented: $isShowing, allowedContentTypes: [.json],   allowsMultipleSelection: false) { result in
                    
                    do {
                        guard let selectedFile: URL = try result.get().first else { return }

                        self.selectedFile = selectedFile
                        validateFile()
                    } catch {
                        // Handle failure.
                    }
                }
            }
            Section {
                Button("Save") {
                    setEnviromentVariables(ip: ipAddress, openai: openai, porcupine: porqupine, llm: llm) { _ in
                        
                    }
                    saveDeviceSettings()
                }
                .disabled(!validateFields())
            }
        }
        .onAppear(){
            populateLLMS()
        }
    }
}

struct SettingsSheetView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsSheetView(ipAddress: .constant("192.168.0.1"),
                          selectedIcon: .constant("house"),
                          name: .constant("Living Room"),
                          location: .constant("Home"),
                          openai: .constant("32sdfsdf"),
                          llm: .constant("gpt-3.5"),
                          porqupine: .constant("dsfdsfdsf"),
                          saveDeviceSettings: {})
    }
}
