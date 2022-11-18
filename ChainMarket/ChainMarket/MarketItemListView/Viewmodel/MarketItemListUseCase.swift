//
//  MarketItemListUseCase.swift
//  ChainMarket
//
//  Created by 오경식 on 2022/11/18.
//

import Foundation

protocol MarketItemListUseCaseProtocol {
    func fetchedItem(completion: @escaping (Result<[MarketItem], NetworkError>) -> Void)
}

final class MarketItemListUseCase: MarketItemListUseCaseProtocol {
    let networkManager: NetworkManager

    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }

    func fetchedItem(completion: @escaping (Result<[MarketItem], NetworkError>) -> Void) {
        networkManager.fetch { result in
            switch result {
            case .success(let data):
                guard let itemList = try? JSONDecoder().decode(MarketItemList.self, from: data) else { return }

                completion(.success(itemList.items))
            case .failure(_):
                completion(.failure(.decodeError))
            }
        }
    }
}
