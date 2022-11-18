//
//  MarketListViewModel.swift
//  ChainMarket
//
//  Created by 오경식 on 2022/11/18.
//

import Foundation

final class MarketItemListViewModel {

    private let useCase: MarketItemListUseCase
    private var listener: ((MarketItem) -> Void)?
    private(set) var marketItems: [MarketItem] = []

    init(useCase: MarketItemListUseCase = MarketItemListUseCase()) {
        self.useCase = useCase
    }

    func bind(_ listener: @escaping (MarketItem) -> Void) {
        self.listener = listener
    }

    func list() {
        useCase.fetchedItem { [weak self] result in
            switch result {
            case .success(let Items):
                self?.marketItems.append(contentsOf: Items)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
