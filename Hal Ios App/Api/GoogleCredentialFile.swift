import Foundation

class APIManager {
    static func validateFile(ip: String, fileURL: URL, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://\(ip):5000/validate_file") else {
            print("Invalid URL")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        let body = createRequestBody(fileURL: fileURL, boundary: boundary)
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
                return
            }
            
            if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let isValid = responseJSON["is_valid"] as? Bool {
                completion(isValid)
            } else {
                print("Invalid response")
                completion(false)
            }
        }.resume()
    }
    
    static func createRequestBody(fileURL: URL, boundary: String) -> Data {
        var body = Data()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        let boundarySuffix = "--\(boundary)--\r\n"
        
        if let fileData = try? Data(contentsOf: fileURL) {
            body.append(Data(boundaryPrefix.utf8))
            body.append(Data("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileURL.lastPathComponent)\"\r\n".utf8))
            body.append(Data("Content-Type: application/octet-stream\r\n\r\n".utf8))
            body.append(fileData)
            body.append(Data("\r\n".utf8))
        }
        
        body.append(Data(boundarySuffix.utf8))
        
        return body
    }
}
