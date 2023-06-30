//
//  CheckConnection.swift
//  Hal Ios App
//
//  Created by Sam Liebert on 6/29/23.
//

import Foundation

func checkConnection(ip: String, completion: @escaping (Bool) -> Void) {
    // Prepare URL
    guard let url = URL(string: "http://\(ip):5000/connected") else {
        completion(false)
        return
    }

    // Prepare URL Request Object
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    // Perform HTTP Request
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        // Check for Error
        if error == nil {
            completion(true)
        } else {
            completion(false)
        }
    }
    task.resume()
}
