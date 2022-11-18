//
//  MarketItemList.swift
//  ChainMarket
//
//  Created by 오경식 on 2022/11/17.
//

import Foundation

struct MarketItemList: Decodable {
    let page: Int
    let items: [MarketItem]
}
