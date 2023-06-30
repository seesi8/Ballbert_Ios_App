//
//  ModifySkills.swift
//  Hal Ios App
//
//  Created by Sam Liebert on 6/29/23.
//

import SwiftUI

struct ModifySkillsView: View {

    let ip: String
    let skill_name: String
    
    @Environment(\.dismiss) private var dismiss
    @State private var activeAlert: ActiveAlert = .confirm
    @State private var showAlert: Bool = false

    
    @State private var formResponse: [String: Any] = [:]
    @State private var sections = [ConfigSection]()
    
    func saveForm(){
        dismiss()

        setSkill(ip: ip, skillName: skill_name, formValues: formResponse) { _ in}
    }
    
    var isFormValid: Bool {
        for section in sections {
            for field in section.fields {
                switch field {
                case .email(let emailField):
                    if let email = formResponse[emailField.name] as? String, email.isEmpty {
                        return false
                    }
                case .password(let passwordField):
                    if let password = formResponse[passwordField.name] as? String, password.isEmpty {
                        return false
                    }
                case .checkbox:
                    // No validation required for checkbox field
                    break
                case .number(let numberField):
                    if let number = formResponse[numberField.name] as? Int?, number == nil {
                        return false
                    }
                case .selection(let selectionField):
                    if let selection = formResponse[selectionField.name] as? String, selection.isEmpty {
                        return false
                    }
                case .label:
                    // No validation required for label field
                    break
                }
            }
        }
        return true
    }

    func populateSections(){
            getSettingsMeta(ip: ip, skill_name: skill_name, completion: { result in
                switch(result){
                case .success(let result):
                    sections = result
                    for section in sections {
                        for field in section.fields{
                            switch(field){
                                
                            case .label(_): break
                            case .password(let theField):
                                formResponse[theField.name] = theField.value
                            case .checkbox(let theField):
                                formResponse[theField.name] = theField.value
                            case .email(let theField):
                                formResponse[theField.name] = theField.value
                            case .number(let theField):
                                formResponse[theField.name] = theField.value
                            case .selection(let theField):
                                formResponse[theField.name] = theField.value
                            }
                        }
                    }
                case .failure(let err):
                    print(err)
                    print("error")
                }
                
            })
        }
    
    var body: some View {
            VStack {
                Form {
                    ForEach(sections, id: \.self) { section in
                        Section(header: Text(section.name)) {
                            sectionFields(for: section)
                        }
                    }
                    
                    Button {
                        showAlert = true
                        activeAlert = .confirm
                    } label: {
                        Text("Delete Skill")
                            .foregroundColor(Color.red)
                    }
                    .alert(isPresented: $showAlert) {
                        switch(activeAlert){
                        case .install :
                            return Alert(
                                title: Text("Error Installing Skill"),
                                message: Text("Check your git link. Feel free to Try again"),
                                dismissButton: .default(Text("Ok"))
                            )
                        case .remove:
                            return Alert(
                                title: Text("Error Removing Skill"),
                                message: Text("Feel free to Try again."),
                                dismissButton: .default(Text("Ok"))
                            )
                        case .conflict:
                            return Alert(
                                title: Text("Skill is required by another"),
                                message: Text("Uninstall other skill to remove"),
                                dismissButton: .default(Text("Ok"))
                            )
                        case .confirm:
                            return Alert(title: Text("Are you sure you want to go Delete"), message: Text("Deleting will remove skill from the device"), primaryButton: .destructive(Text("Delete")) {
                                dismiss()
                                removeSkill(ip: ip, skill_name: skill_name) { res in
                                    switch res {
                                    case.failure( _):
                                        showAlert = true
                                        activeAlert = .remove
                                    case .success(let result):
                                        if let dictionary = result as? [String: Int], dictionary["status_code"] == 200{
                                            print(result)
                                        }
                                        else if let dictionary = result as? [String: Int], dictionary["status_code"] == 409{
                                            showAlert = true
                                            activeAlert = .conflict
                                            
                                        }
                                        else{
                                            showAlert = true
                                            activeAlert = .remove
                                        }
                                    }
                                }
                            },
                                         secondaryButton: .cancel())
                        }
                    }

                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
                
                Button(action: {
                    saveForm()
                }, label: {
                    Text("Save")
                        .font(.headline)
                        .padding()
                })
                .disabled(!isFormValid)
            }
            .onAppear {
                populateSections()
            }

        }
        
        @ViewBuilder
        private func sectionFields(for section: ConfigSection) -> some View {
            ForEach(section.fields, id: \.self) { field in
                fieldView(for: field)
            }
        }
        
        @ViewBuilder
    private func fieldView(for field: ConfigSection.ConfigField) -> some View {
            switch field {
            case .email(let emailField):
                TextField(emailField.label, text: Binding(
                    get: { formResponse[emailField.name] as? String ?? "" },
                    set: { newValue in formResponse[emailField.name] = newValue }
                ))
            case .label(let labelField):
                Text(labelField.value)
            case .password(let passwordField):
                SecureField(passwordField.label, text: Binding(
                    get: { formResponse[passwordField.name] as? String ?? "" },
                    set: { newValue in formResponse[passwordField.name] = newValue }
                ))
            case .checkbox(let checkboxField):
                Toggle(checkboxField.label, isOn: Binding(
                    get: { formResponse[checkboxField.name] as? Bool ?? false },
                    set: { newValue in formResponse[checkboxField.name] = newValue }
                ))
            case .number(let numberField):
                TextField(numberField.label, text: Binding(
                    get: {
                        let x = formResponse[numberField.name] as? Int
                        var str = ""
                        if let v = x {
                            str = "\(v)"
                        }
                        return str
                    },
                    set: { newValue in
                        if newValue.range(
                            of: "^[0-9]*$",
                            options: .regularExpression) != nil {
                            formResponse[numberField.name] = Int(newValue)
                        }
                    }
                ))
            case .selection(let selectionField):
                Picker(selection: Binding(
                    get: { formResponse[selectionField.name] as? String ?? "" },
                    set: { newValue in formResponse[selectionField.name] = newValue }
                ), label: Text(selectionField.label)) {
                    ForEach(selectionField.options, id: \.self) { option in
                        Text(option.value).tag(option.name)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
}

struct ModifySkillsView_Previews: PreviewProvider {
    static var previews: some View {
        ModifySkillsView(ip: "192.168.86.143", skill_name: "AdvancedMath")
    }
}
