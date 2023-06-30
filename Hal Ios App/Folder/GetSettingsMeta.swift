//  GetInstalledSkills.swift
//  Hal Ios App
//
//  Created by Sam Liebert on 6/29/23.
//
import SwiftUI
import Foundation

struct NumberField: Hashable {
    let name: String
    let type: String
    let label: String
    let value: Int
}

struct EmailField: Hashable {
    let name: String
    let type: String
    let label: String
    var value: String
}

struct CheckboxField: Hashable {
    let name: String
    let type: String
    let label: String
    let value: Bool
}

struct PasswordField: Hashable {
    let name: String
    let type: String
    let label: String
    let value: String
}

struct SelectionOption: Hashable {
    let name: String
    let value: String
}

struct SelectionField: Hashable {

    let name: String
    let type: String
    let label: String
    let options: [SelectionOption]
    let value: String

}

struct LabelField: Hashable {
    let type: String
    let value: String
}

struct ConfigSection: Hashable {
    enum ConfigField: Hashable {
        case label(LabelField)
        case password(PasswordField)
        case checkbox(CheckboxField)
        case email(EmailField)
        case number(NumberField)
        case selection(SelectionField)
    }
    
    let name: String
    let fields: [ConfigField]
}

func getSettingsMeta(ip: String, skill_name: String, completion: @escaping (Result<[ConfigSection], Error>) -> Void) {
    // Prepare URL
    guard let url = URL(string: "http://\(ip):5000/get_settings_meta_for_skill?skill_name=\(skill_name)") else {
        fatalError("Invalid URL")
    }

    // Prepare URL Request Object
    var request = URLRequest(url: url)
    request.httpMethod = "GET"

    // Perform HTTP Request
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            completion(.failure(error))
            return
        }

        if let data = data {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                if let dict = jsonObject as? [String: Any], let settingsDict = dict["settings"] as? [String: Any], let metadataDict = settingsDict["skillMetadata"] as? [String: Any] {
                    var configSections: [ConfigSection] = []

                    guard let sections = metadataDict["sections"] as? [[String: Any]] else {
                        completion(.failure(NSError(domain: "Data Sections Error", code: 0, userInfo: nil)))
                        return
                    }

                    for section in sections {
                        guard let sectionName = section["name"] as? String, let fields = section["fields"] as? [[String: Any]] else {
                            completion(.failure(NSError(domain: "Data Section Error", code: 0, userInfo: nil)))
                            return
                        }

                        var configFields: [ConfigSection.ConfigField] = []

                        for field in fields {
                            guard let fieldType = field["type"] as? String else {
                                completion(.failure(NSError(domain: "Data Field Error Base", code: 0, userInfo: nil)))
                                return
                            }

                            switch fieldType {
                            case "label":
                                if let fieldValue = field["value"] as? String? ?? ""  {
                                    let labelField = LabelField(type: fieldType, value: fieldValue)
                                    configFields.append(.label(labelField))
                                } else {
                                    completion(.failure(NSError(domain: "Data Field Value Error label", code: 0, userInfo: nil)))
                                    return
                                }

                            case "password":
                                if let fieldName = field["name"] as? String,
                                    let fieldValue = field["value"] as? String? ?? "",
                                   let fieldLabel = field["label"] as? String  {
                                    let passwordField = PasswordField(name: fieldName, type: fieldType, label: fieldLabel, value: fieldValue)
                                    configFields.append(.password(passwordField))
                                } else {
                                    completion(.failure(NSError(domain: "Data Field Value Error password", code: 0, userInfo: nil)))
                                    return
                                }

                            case "checkbox":
                                if let fieldName = field["name"] as? String,
                                    let fieldValue = field["value"] as? Bool,
                                   let fieldLabel = field["label"] as? String  {
                                    let checkboxField = CheckboxField(name: fieldName, type: fieldType, label: fieldLabel, value: fieldValue)
                                    configFields.append(.checkbox(checkboxField))
                                } else {
                                    completion(.failure(NSError(domain: "Data Field Value Error checkbox", code: 0, userInfo: nil)))
                                    return
                                }

                            case "email":
                                if let fieldName = field["name"] as? String,
                                    let fieldValue = field["value"] as? String? ?? "",
                                   let fieldLabel = field["label"] as? String  {
                                    let emailField = EmailField(name: fieldName, type: fieldType, label: fieldLabel, value: fieldValue)
                                    configFields.append(.email(emailField))
                                } else {
                                    completion(.failure(NSError(domain: "Data Field Value Error email", code: 0, userInfo: nil)))
                                    return
                                }

                            case "number":
                                if let fieldName = field["name"] as? String,
                                    let fieldValue = field["value"] as? Int,
                                   let fieldLabel = field["label"] as? String  {
                                    let numberField = NumberField(name: fieldName, type: fieldType, label: fieldLabel, value: fieldValue)
                                    configFields.append(.number(numberField))
                                } else {
                                    completion(.failure(NSError(domain: "Data Field Value Error number", code: 0, userInfo: nil)))
                                    return
                                }

                            case "select":
                                if let fieldName = field["name"] as? String,
                                   let fieldValue = field["value"] as? String? ?? "",
                                    let fieldOptionsDict = field["options"] as? [String: String],
                                   let fieldLabel = field["label"] as? String  {
                                    var fieldOptions: [SelectionOption] = []
                                    
                                    for (key,value) in fieldOptionsDict{
                                        let fieldOption = SelectionOption(name: value, value: key)
                                        fieldOptions.append(fieldOption)
                                    }
                                    let selectionField = SelectionField(name: fieldName, type: fieldType, label: fieldLabel, options: fieldOptions, value: fieldValue)
                                    configFields.append(.selection(selectionField))
                                } else {
                                    completion(.failure(NSError(domain: "Data Field Value Error selecetion", code: 0, userInfo: nil)))
                                    return
                                }

                            default:
                                print(fieldType)
                                completion(.failure(NSError(domain: "Unknown Field Type", code: 0, userInfo: nil)))
                                return
                            }
                        }

                        let configSection = ConfigSection(name: sectionName, fields: configFields)
                        configSections.append(configSection)
                    }

                    completion(.success(configSections))

                } else {
                    completion(.failure(NSError(domain: "DataError", code: 0, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        } else {
            completion(.failure(NSError(domain: "Data Data Error", code: 0, userInfo: nil)))
        }
    }

    task.resume()
}
