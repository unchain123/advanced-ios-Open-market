//
//  NetworkManager.swift
//  ChainMarket
//
//  Created by 오경식 on 2022/11/17.
//

import Foundation

final class NetworkManager {
    private let session: URLSession
    static let okStatusCode: Range<Int> = (200 ..< 300)

    init(session: URLSession = .shared) {
        self.session = session
    }

    private func networkPerform(for request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let dataTask: URLSessionDataTask = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.urlRequest(error)))
                return
            }
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.invalidHTTPResponse))
                return
            }
            guard NetworkManager.okStatusCode ~= response.statusCode else {
                completion(.failure(.invalidHttpStatusCode(response.statusCode)))
                return
            }
            guard let data = data else {
                completion(.failure(.emptyData))
                return
            }
            completion(.success(data))
        }
        dataTask.resume()
    }

    private func fetch(completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let request = try? EndPoint.list(page: 1, itemPerPage: 20).createURLRequest() else { return }
        print(request.description)
        networkPerform(for: request, completion: completion)
    }

    func fetchList(completion: @escaping (Result<[MarketItem], NetworkError>) -> Void) {
        fetch() { result in
            switch result {
            case .success(let data):
                guard let item = try? JSONDecoder().decode(MarketInformation.self, from: data) else {
                    print("디코딩error")
                    return }
                completion(.success(item.pages))
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
    }
}
