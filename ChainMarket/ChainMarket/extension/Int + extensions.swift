//
//  Int + extensions.swift
//  ChainMarket
//
//  Created by 오경식 on 2022/11/23.
//

import Foundation

extension NumberFormatter {

    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Int {

    func priceFormatted() -> String {
        return NumberFormatter.priceFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
