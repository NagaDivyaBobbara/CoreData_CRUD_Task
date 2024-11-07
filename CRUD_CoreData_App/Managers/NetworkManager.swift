//
//  NetworkManager.swift
//  CRUDApp
//
//  Created by Naga Divya Bobbara on 08/11/24.
//

import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    // Base URL
    private let baseURL = "https://sandbox.cynergytx.com/system-task"
    
    // Headers
    private let headers: HTTPHeaders = [
        "Content-Type": "application/x-www-form-urlencoded",
        // Add other headers if required (e.g., Authorization: Bearer <token>)
    ]
    
    func createOrUpdateUser(parameters: [String: Any], completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(baseURL)/createUser"
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    print("User created/updated successfully: \(data)")
                    completion(.success("User created/updated successfully"))
                case .failure(let error):
                    print("Error in creating/updating user: \(error)")
                    completion(.failure(error))
                }
            }
    }
    
    func deleteUser(email: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(baseURL)/deletUser"
        let parameters: [String: Any] = ["email": email]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    print("User deleted successfully: \(data)")
                    completion(.success("User deleted successfully"))
                case .failure(let error):
                    print("Error in deleting user: \(error)")
                    completion(.failure(error))
                }
            }
    }
    
    func getAllUsers(completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let url = "\(baseURL)/getAllUsers"
        
        AF.request(url, method: .get, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    print("Fetched all users successfully: \(data)")
                    if let jsonData = data as? [String: Any] {
                        completion(.success(jsonData))
                    }
                case .failure(let error):
                    print("Error in fetching users: \(error)")
                    completion(.failure(error))
                }
            }
    }
}
