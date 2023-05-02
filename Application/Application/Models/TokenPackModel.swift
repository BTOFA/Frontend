//
//  TokenPackModel.swift
//  Application
//
//  Created by Максим Кузнецов on 02.05.2023.
//

import UIKit

struct TokenPackModel: Codable {
    
    let id: Int64?
    
    let user: UserModel?
    
    let token: TokenModel?
    
    let amount: Int64?
}
