//
//  OperationModel.swift
//  Application
//
//  Created by Максим Кузнецов on 02.05.2023.
//

import UIKit

struct OperationModel: Codable {
    
    let id: Int64?
    
    let user: UserModel?
    
    let type: String?
    
    let description: String?
    
    let date: String?
}
