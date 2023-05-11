//
//  ApiService.swift
//  Application
//
//  Created by Максим Кузнецов on 02.05.2023.
//

import UIKit
import Foundation

enum APIError: Error {
    case failedToGetData
}

final class APIService {
    
    // MARK: - Properties.
    
    private let serverUrl = ""
    
    // MARK: - Static instance of API for external classes.
    
    static var shared = {
        APIService()
    }()
    
    // MARK: - getUserTokens function.
    
    func getUserTokens(completion: @escaping (Result<[TokenPackModel], Error>) -> Void) {
        
        guard let url = URL(
            string: "\(serverUrl)/.../..."
        ) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode([TokenPackModel].self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }.resume()
    }
    
    // MARK: - registerUser function.
    
    func registerUser(wallet: String, password: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/api/register_user")!)
        let params: [String: Any] = ["wallet": wallet,
                                    "password": password]
        let body = try? JSONSerialization.data(withJSONObject: params)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        request.httpBody = body
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            print(String(decoding: data, as: UTF8.self))
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        task.resume()
    }
}
