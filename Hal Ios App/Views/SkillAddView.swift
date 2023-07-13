//
//  SkillAddView.swift
//  Hal Ios App
//
//  Created by Sam Liebert on 6/29/23.
//
import Foundation
import SwiftUI

enum ActiveAlert {
    case install, remove, conflict, confirm
}


struct SkillAddView: View {
    let ip: String
    @State private var url: String = ""
    @State private var skills: [Skill] = []
    @State private var isLoading: Bool = false
    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .install

    
    
    
    func addButtonTapped() {
        addSkill(ip: ip, gitURL: url) { res in
            populateInstalledSkills()
            isLoading = false
            switch res {
            case.failure( _):
                showAlert = true
                activeAlert = .install
            case .success(let result):
                if let dictionary = result as? [String: Int], dictionary["status_code"] == 200{
                    print(result)
                }
                else{
                    showAlert = true
                    activeAlert = .install
                }
            }
        }
        isLoading = true
    }
    
    func populateInstalledSkills() {
        getInstalledSkills(ip: "192.168.86.143") { result in
            switch result {
            case .success(let result):
                skills = result
            case .failure(let error):
                // Handle the error
                print("Error: \(error)")
            }
        }
    }

    
    var body: some View {
        VStack {
            VStack{
                Text("Enter Git Url")
                    .font(.headline)
                    .fontWeight(.semibold)
                HStack{
                    TextField("Search", text: $url)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    Button("Add") {
                        addButtonTapped()
                    }
                    .alert(isPresented: $showAlert) {
                        switch activeAlert {
                            
                        case .install:
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
                            return Alert(title: Text("Are you sure you want to go Delete"))
                        }
                    }
                    .padding(.trailing)
                    
                    
                }
            }
            if isLoading{
                ProgressView()
                    .padding(.bottom, 4.0)
            }

            List {
                ForEach(skills, id: \.self){ skill in
                    NavigationLink(destination: ModifySkillsView(
                        ip: ip, skill_name: skill.name
                    )){
                    HStack{
                        Text(skill.name)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    removeSkill(ip: ip, skill_name: skill.name) { res in
                                        populateInstalledSkills()
                                        isLoading = false
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
                                    isLoading = true
                                } label: {
                                    Image(systemName: "trash")
                                }
                                
                                
                            }
                    }
                }
                }
                
            }
            
        }
        .onAppear{
            populateInstalledSkills()
        }
    }
}


struct SkillAddView_Previews: PreviewProvider {
    static var previews: some View {
        SkillAddView(ip: "192.168.86.143")
    }
}
