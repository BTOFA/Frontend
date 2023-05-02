//
//  UserModel.swift
//  Application
//
//  Created by Максим Кузнецов on 02.05.2023.
//

import UIKit

struct UserModel: Codable {
    
    let id: Int64?
    
    let role: String?
    
    let address: String?
    
    let balance: Int64?
}
