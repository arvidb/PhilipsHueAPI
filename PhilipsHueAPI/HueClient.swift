import Foundation

public enum ConnectionResult<T1, T2> {
    case success(T1)
    case failure(T2)
}

class HueClient {
    
    private let session: URLSessionProtocol
    
    let hostname: String
    var username: String?
    
    var apiBaseURL: URL {
        get {
            return URL(string: "http://\(self.hostname)/api/")!
        }
    }
    
    var apiURL: URL {
        get {
            guard let username = username else { fatalError("Unauthorized") }
            
            return apiBaseURL.appendingPathComponent(username)
        }
    }
    
    init(withHostname hostname: String, username: String? = nil, session: URLSessionProtocol) {
        self.hostname = hostname
        self.username = username
        
        self.session = session
    }
    
    func isAuthorized(username: String) {
        // TODO
    }
    
    struct HueError: Codable {
        let type: Int
        let address: String
        let description: String
    }
    
    func register(applicationWithName appName: String, deviceName: String, completion: @escaping (_ result: ConnectionResult<String, String>) -> Void) {
        
        var data = [String: String]()
        data["devicetype"] = "\(appName)#\(deviceName)"
        
        let url = self.apiBaseURL
        postObject(object: data, url: url, completion: {
            (result) in
            
            switch result {
            case .success(let dict):
                if let errorKey = dict["error"] as? [String: Any],
                    let description = errorKey["description"] as? String {
                    
                    completion(.failure(description))
                } else if let successKey = dict["success"] as? [String: String],
                    let username = successKey["username"] {
                    
                    completion(.success(username))
                } else {
                    
                    completion(.failure("Unable to parse response"))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}

extension HueClient {
    
    func getObjects<T: HuePeripheral>(_: T.Type, url: URL, completion: @escaping (_ result: ConnectionResult<[T], String>) -> Void) {
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {
                completion(.failure(error?.localizedDescription ?? "No data returned"))
                return
            }
            
            do {
                let jsonDict = try JSONDecoder().decode([String : T].self, from: data)
                
                let results = jsonDict.reduce(into: [T]()) { (result, tuple) in
                    var v = tuple.value
                    v.identifier = tuple.key
                    result.append(v)
                }
                
                completion(.success(results))
                
            } catch let error as NSError {
                completion(.failure(error.localizedDescription))
            }
        }
        
        task.resume()
    }
    
    func getObject<T: HuePeripheral & Codable>(_: T.Type, id: String, url: URL, completion: @escaping (_ result: ConnectionResult<T, String>) -> Void) {
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {
                completion(.failure(error?.localizedDescription ?? "No data returned"))
                return
            }
            
            do {
                var result = try JSONDecoder().decode(T.self, from: data)
                result.identifier = id
                completion(.success(result))
                
            } catch let error as NSError {
                completion(.failure(error.localizedDescription))
            }
        }
        
        task.resume()
    }
    
    func postObject<T: Codable>(object: T, url: URL, completion: @escaping (_ result: ConnectionResult<[String: Any], String>) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let uploadData = try? JSONEncoder().encode(object) else {
            completion(.failure("Failed to encode object"))
            return
        }
        
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { (data, response, error) in
            
            if let error = error {
                
                completion(.failure("error: \(error)"))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    completion(.failure("server error"))
                    return
            }
            
            if let mimeType = response.mimeType,
                mimeType == "application/json",
                let data = data {
                
                do {
                    let parsed = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String:Any]]
                    if let first = parsed.first {
                        
                        completion(.success(first))
                    }
                    
                } catch let error as NSError {
                    completion(.failure(error.localizedDescription))
                }
            }
        }
        
        task.resume()
    }
}
