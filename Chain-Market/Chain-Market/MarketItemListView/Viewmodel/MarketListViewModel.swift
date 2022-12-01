//
//  MarketListViewModel.swift
//  ChainMarket
//
//  Created by 오경식 on 2022/11/18.
//

import Foundation

enum Action {
    case viewDidLoad
    case button
}

final class MarketItemListViewModel {

    var delegate: CustomDelegate?
    let networkManager: NetworkManager = NetworkManager()
    private var listener: (([MarketItem]) -> Void)?
    private var marketItems: [MarketItem] = []

    func action(_ action: Action) {
        switch action {
        case .viewDidLoad:
            list()
        case .button:
            print("버튼")
        }
    }

    func bind(_ listener: @escaping ([MarketItem]) -> Void) {
        self.listener = listener
    }

    private func list() {
        networkManager.fetchList { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.marketItems = success
                self.delegate?.delegate(input: self.marketItems)
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
    }
}

protocol CustomDelegate {
    func delegate(input: [MarketItem])
}
