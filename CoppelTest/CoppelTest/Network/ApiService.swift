//
//  ApiService.swift
//  CoppelTest
//
//  Created by Javier Morales on 26/10/21.
//

import Foundation

enum CoppelApiError: Error {
    case parseJsonFailed
    case unexpected(code: Int)
}

extension CoppelApiError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .parseJsonFailed:
            return "parse json failed"
        case .unexpected(code: _):
            return "An unexpected error occurred."
        }
    }
}

enum ApiService {
    enum RequestType: String {
        case POST
        case GET
        case PUT
        case DELETE
    }
    
    private static let baseURLv3 = "https://api.themoviedb.org/3"
    private static let api_key = "9e41694ddf2f504b03d4441d4b85e851"
    
    public static func loginApiRequest(completion:@escaping (LoginStatus?) -> Void   ) {
        guard let url = URL(string: "\(baseURLv3)/authentication/token/new?api_key=9e41694ddf2f504b03d4441d4b85e851") else {
            completion(nil)
            return
        }

        makeRequestReturnDict(url: url, method: .GET, parameters: nil) { (dict, error) in
            guard let dict = dict else {
                completion(nil)
                return
            }
            
            if let request_token = dict["request_token"] as? String {
                completion(LoginStatus.success(token: request_token))
                return
            }
            completion(nil)
        }
    }
    
    public static func loginGetToken(params: [String:Any], completion: @escaping(LoginStatus?) -> Void) {
        
        guard let url = URL(string: "\(baseURLv3)/authentication/token/validate_with_login?api_key=9e41694ddf2f504b03d4441d4b85e851") else {
            completion(nil)
            return
        }
        makeRequestReturnDict(url: url, method: .POST, parameters: params) { dict, error in
            guard let dict = dict else {
                completion(nil)
                return
            }
            
            if let request_token = dict["request_token"] as? String {
                completion(LoginStatus.success(token: request_token))
                return
            }
            completion(nil)
        }
    }

}



extension ApiService {
    fileprivate static func makeRequestReturnDict(url: URL, method:RequestType, parameters: [String:Any]?, completionHandler: @escaping  ([String:Any]?, Error?) -> Void) {
        makeRequest(url: url, method: method, parameters: parameters) { (object, error) in
            guard let theObject = object, let dict = theObject as? [String: Any] else {
                completionHandler(nil, error)
                return
            }
            completionHandler(dict, nil)
        }
    }
    
    fileprivate static func makeRequest(url: URL, method:RequestType, parameters: [String:Any]?, completionHandler: @escaping  (Any?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if method == .POST {
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            // compose http body
            if let theParameters = parameters {
                let jsonData = try? JSONSerialization.data(withJSONObject: theParameters)
                request.httpBody = jsonData
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    DispatchQueue.main.async {
                        completionHandler(json, nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completionHandler(nil, CoppelApiError.parseJsonFailed)
                    }
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    completionHandler(nil,error)
                }
            } else {
                // no data, no error
                DispatchQueue.main.async {
                    completionHandler(nil, CoppelApiError.unexpected(code: -1))
                }
            }
        }
        task.resume()
    }
}
