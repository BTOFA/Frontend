//
//  History.swift
//  Application
//

import UIKit

struct UserHistoryResponse: Codable {
    let status: String
    let history: [History]
    
    enum CodingKeys: String, CodingKey {
        case status
        case history = "history"
    }
}

struct History: Codable {
    let desc: String
    let opType: String
    let performed: String
    
    enum CodingKeys: String, CodingKey {
        case desc, performed, opType = "op_type"
    }
}
