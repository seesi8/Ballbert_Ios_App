import Foundation

func checkOpenaiApiKey(ip: String, key: String, completion: @escaping (Bool?) -> Void) {
    // URL of the API endpoint
    guard let url = URL(string: "http://\(ip):5000/test_openai_api_key?api_key=\(key)") else {
        completion(nil) // Return nil if the URL is invalid
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("Error: \(error)")
            completion(nil) // Return nil if there's an error
            return
        }
        
        if let data = data {
            if let responseString = String(data: data, encoding: .utf8) {
                if let apiResponse = Bool(responseString) {
                    completion(apiResponse) // Return the API response as a Bool
                } else {
                    completion(nil) // Return nil if the API response cannot be converted to Bool
                }
            } else {
                completion(nil) // Return nil if the API response data cannot be converted to a string
            }
        } else {
            completion(nil) // Return nil if the API response data is nil
        }
    }
    
    task.resume()
}
