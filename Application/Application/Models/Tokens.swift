//
//  Tokens.swift
//  Application
//

import UIKit

struct TokenSeriesResponse: Codable {
    let status: String
    let tokenSeries: [TokenSeries]
    
    enum CodingKeys: String, CodingKey {
        case status
        case tokenSeries = "tokens_series"
    }
}

struct TokenSeries: Codable {
    let id: Int
    let name: String
    let leftId: Int
    let rightId: Int
    let lastId: Int
    let numberOfTokens: Int
    let cost: Int
    let metainfo: String
    let created: String
    let expirationDatetime: String
    let dividends: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, leftId = "left_id", rightId = "right_id", lastId = "last_id"
        case numberOfTokens = "number_of_tokens", cost, metainfo, created, expirationDatetime = "expiration_datetime", dividends
    }
}

struct TokenModel: Codable {
    let id: Int
    let name: String
    let amount: Int
    let expirationDatetime: String
}
