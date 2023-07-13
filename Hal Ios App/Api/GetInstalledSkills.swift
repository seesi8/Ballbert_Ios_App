//
//  GetInstalledSkills.swift
//  Hal Ios App
//
//  Created by Sam Liebert on 6/29/23.
//

import Foundation


struct Skill: Hashable {
    let name: String
    let version: Int
    let actions: [String]
    let image: String
}

func getInstalledSkills(ip: String, completion: @escaping (Result<[Skill], Error>) -> Void) {
    // Prepare URL
    guard let url = URL(string: "http://\(ip):5000/get_installed_skills") else {
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
                    if let dict = jsonObject as? [String: Any], let skillsDict = dict["skills"] as? [String: Any] {
                        var skills = [Skill]()
                        for (_, skillData) in skillsDict {
                            if let skillDict = skillData as? [String: Any],
                               let name = skillDict["name"] as? String,
                               let version = skillDict["version"] as? Int,
                               let actions = skillDict["actions"] as? [String],
                               let image = skillDict["image"] as? String {
                                let skill = Skill(name: name, version: version, actions: actions, image: image)
                                skills.append(skill)
                            }
                        }
                        completion(.success(skills))
                    } else {
                        completion(.failure(NSError(domain: "DataError", code: 0, userInfo: nil)))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: "DataError", code: 0, userInfo: nil)))
            }
        }

        task.resume()
}

