//
//  TokenModel.swift
//  Application
//
//  Created by Максим Кузнецов on 18.04.2023.
//

import UIKit

struct TokenModel: Codable {
    
    let id: Int64?
    
    let name: String?
    
    let amount: Int64?
    
    let price: Int64?
    
    let emissionDate: String?
    
    let burnDate: String?
    
    let profit: Int64?
    
    let metadata: String?
}
