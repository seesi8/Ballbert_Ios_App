import Foundation


func addSkill(ip: String, gitURL: String, completion: @escaping (Result<Any, Error>) -> Void) {
    // Prepare URL
    guard let url = URL(string: "http://\(ip):5000/add_skill") else {
        fatalError("Invalid URL")
    }

    // Prepare URL Request Object
    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    let requestBody: [String: Any] = [
        "url": gitURL
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

