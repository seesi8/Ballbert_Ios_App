//
//  getMicrophones.swift
//  Hal Ios App
//
//  Created by Sam Liebert on 7/12/23.
//

import Foundation

func getLLMS(ip: String, api_key: String, completion: @escaping ([String]?, Error?) -> Void) {
    guard let url = URL(string: "http:/\(ip):5000/get_llms?api_key=\(api_key)") else {
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
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String]
            completion(json, nil)
        } catch {
            completion(nil, error)
        }
    }

    task.resume()
}
