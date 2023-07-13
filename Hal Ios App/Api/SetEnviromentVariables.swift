//
//  SetEnviromentVariables.swift
//  Hal Ios App
//
//  Created by Sam Liebert on 7/12/23.
//

import Foundation


func setEnviromentVariables(ip: String, openai: String, porcupine: String, llm:String , completion: @escaping (Result<Any, Error>) -> Void) {
    // Prepare URL
    guard let url = URL(string: "http://\(ip):5000/set_enviroment_variables") else {
        fatalError("Invalid URL")
    }

    // Prepare URL Request Object
    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    let requestBody: [String: Any] = [
        "variables": [
            "OPENAI_API_KEY": openai,
            "PORQUPINE_API_KEY": porcupine,
            "LLM": llm,
        ]
    ]

    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    } catch {
        completion(.failure(error))
        return
    }

    // Perform HTTP Request
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            completion(.failure(error))
            return
        }

        if let data = data {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                completion(.success(jsonObject))
            } catch {
                completion(.failure(error))
            }
        } else {
            completion(.failure(NSError(domain: "DataError", code: 0, userInfo: nil)))
        }
    }
    task.resume()
}

