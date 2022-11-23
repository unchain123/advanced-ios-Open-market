//
//  MarketListViewModel.swift
//  ChainMarket
//
//  Created by 오경식 on 2022/11/18.
//

import Foundation
import UIKit.UIImage

final class MarketItemListViewModel {

    // MARK: View model type
    struct MetaData {
        let title: String
        var thumbnail: UIImage?
        let hasDiscountedPrice: Bool
        let discountedPrice: NSAttributedString
        let price: String
        let isOutOfStock: Bool
        let stock: String
    }

    enum State {
        case empty
        case update(MarketItemListViewModel.MetaData)
        case error(NetworkError)
    }

    private let useCase: MarketItemListUseCase
    private var listener: ((State) -> Void)?
    private(set) var marketItem: MarketItem
    private(set) var marketItems: [MarketItem] = []

    init(useCase: MarketItemListUseCase = MarketItemListUseCase(), marketItem: MarketItem) {
        self.useCase = useCase
        self.marketItem = marketItem
    }

    func bind(_ listener: @escaping (State) -> Void) {
        self.listener = listener
    }

    func fire() {
        setDataTexts()
    }

    private func setDataTexts() {
        let title = marketItem.name
        let hasDiscountedPrice = marketItem.discountedPrice != nil
        let discountedPrice: NSAttributedString = hasDiscountedPrice ? "\(marketItem.currency) \(marketItem.discountedPrice?.priceFormatted())".strikeThrough() : NSAttributedString()
        let price = hasDiscountedPrice ? "\(marketItem.currency) \(marketItem.discountedPrice?.priceFormatted() ?? "")" : "\(marketItem.currency) \(marketItem.price.priceFormatted())"
        let isOutOfStock = marketItem.stock == .zero
        let stock = isOutOfStock ? "품절" : "잔여수량 : \(marketItem.stock.priceFormatted())"
        let metaData = MetaData(title: title,
                                hasDiscountedPrice: hasDiscountedPrice,
                                discountedPrice: discountedPrice,
                                price: price,
                                isOutOfStock: isOutOfStock,
                                stock: stock)
    }

    func list() {
        useCase.fetchedItem { [weak self] result in
            switch result {
            case .success(let items):
                self?.marketItems.append(contentsOf: items)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
