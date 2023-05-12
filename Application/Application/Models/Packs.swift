//
//  Packs.swift
//  Application
//

import UIKit

struct PacksResponse: Codable {
    let status: String
    let packs: [Pack]
}

struct Pack: Codable {
    let wallet: String
    let tokenSeries: Int
    let numberOfTokens: Int
    let leftId: Int
    let rightId: Int

    enum CodingKeys: String, CodingKey {
        case wallet = "wallet "
        case tokenSeries = "token_series"
        case numberOfTokens = "number_of_tokens"
        case leftId = "left_id"
        case rightId = "right_id"
    }
}
