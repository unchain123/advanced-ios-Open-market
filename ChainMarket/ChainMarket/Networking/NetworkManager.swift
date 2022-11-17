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

    init(session: URLSession) {
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
}
