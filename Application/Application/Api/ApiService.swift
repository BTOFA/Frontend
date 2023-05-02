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
}
