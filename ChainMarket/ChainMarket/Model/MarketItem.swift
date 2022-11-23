//
//  MarketItem.swift
//  ChainMarket
//
//  Created by 오경식 on 2022/11/17.
//

import Foundation

struct MarketItem: Decodable, Hashable {
    let id: Int
    let vendorId: Int
    let vendorName: String
    let name: String
    let description: String
    let thumbnail: String?
    let currency: String
    let price: Int
    let bargainPrice: Int?
    let discountedPrice: Int?
    let stock: Int
    let createdAt: Date
    let issuedAt: Date
    let images: [Images]?

    enum CodingKeys: String, CodingKey {
        case id
        case vendorId = "vendor_id"
        case vendorName = "vendor_name"
        case name
        case description
        case thumbnail
        case currency
        case price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case createdAt = "created_at"
        case issuedAt = "issued_at"
        case images
    }
}

struct Images: Decodable, Hashable {
    let id: Int
    let url: String
    let thumbnailUrl: String
    let succeed: Bool
    let issuedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case thumbnailUrl = "thumbnail_url"
        case succeed
        case issuedAt = "issued_at"
    }
}
