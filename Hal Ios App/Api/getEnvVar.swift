//
//  getEnvVar.swift
//  Hal Ios App
//
//  Created by Sam Liebert on 7/13/23.
//

import Foundation

func getEnviromentVariables(ip: String, key: String, completion: @escaping (String?, Error?) -> Void) {
    guard let url = URL(string: "http://\(ip):5000/get_enviroment_variable?key=\(key)") else {
        let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        completion(nil, error)
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            completion(nil, error)
            return
        }
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200,
              let data = data else {
            let error = NSError(domain: "Invalid Response", code: 0, userInfo: nil)
            completion(nil, error)
            return
        }

        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let keyValue = json["key"] as? String {
                completion(keyValue, nil)
            } else {
                let error = NSError(domain: "Invalid JSON or Key", code: 0, userInfo: nil)
                completion(nil, error)
            }
        } catch {
            completion(nil, error)
        }
    }

    task.resume()
}
