//
//  PostModel.swift
//  Chain-Market
//
//  Created by 오경식 on 2022/12/14.
//

import Foundation

struct PostItem: Encodable {
    let name: String
    let description: String
    let currency: CurrencyUnit
    let price: Double
    var discountedPrice: Double
    var stock: Int
    let secret: String = APIConstants.secret

    enum CurrencyUnit: String, Encodable {
        case KRW
        case USD
    }

    enum CodingKeys: String, CodingKey {
        case name, description, currency, price, stock, secret
        case discountedPrice = "discounted_price"
    }
}

enum Multipart {
    static let boundaryValue = "\(UUID().uuidString)"
}
