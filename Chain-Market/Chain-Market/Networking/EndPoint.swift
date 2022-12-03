//
//  EndPoint.swift
//  ChainMarket
//
//  Created by 오경식 on 2022/11/17.
//

import Foundation

protocol RequestProtocol {
    var path: String { get }
    var queries: [String: String] { get }
    var httpMethod: HTTPMethod { get }
    var headers: [String: String] { get }

    func createURLRequest() throws -> URLRequest
}

enum HTTPMethod: String {
    case get
    case post
    case patch
    case del

    var kind: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .patch:
            return "PATCH"
        case .del:
            return "DELETE"
        }
    }
}

enum APIConstants {
    static let scheme = "https"
    static let host = "openmarket.yagom-academy.kr"
    static let name = "sixthVendor"
    static let accessID = "sixthVendor"
    static let secret = "ebs12345"
    static let identifier = "7184295e-4aa1-11ed-a200-354cb82ae52e"
}

extension URLRequest {
    init(
        url: URL,
        httpMethod: HTTPMethod
    ) {
        self.init(url: url)
        self.httpMethod = httpMethod.kind
    }
}

extension RequestProtocol {
    var scheme: String {
        return APIConstants.scheme
    }

    var host: String {
        return APIConstants.host
    }

    func createURLRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path

        components.queryItems = queries.map(URLQueryItem.init(name:value:))
        guard let url = components.url else { throw NetworkError.components }

        let urlRequest = URLRequest(url: url, httpMethod: httpMethod)

        return urlRequest
    }
}

enum EndPoint: RequestProtocol {
    case list(page: Int, itemPerPage: Int = 20)

    var path: String {
        switch self {
        default:
            return "/api/products"
        }
    }

    var queries: [String: String] {
        switch self {
        case let .list(page, itemPerPage):
            return ["page_no": "\(page)",
                    "items_per_page": "\(itemPerPage)"]
        default:
            return [:]
        }
    }

    var httpMethod: HTTPMethod {
        return HTTPMethod.get
    }

    var headers: [String: String] {
        return [:]
    }
}
