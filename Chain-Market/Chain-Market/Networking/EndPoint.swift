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
    var isNeedIdentifier: Bool { get }

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
    static let passwordKey = "secret"
    static let secret = "ebs12345"
    static let identifier = "7184295e-4aa1-11ed-a200-354cb82ae52e"
    //"7184295e-4aa1-11ed-a200-354cb82ae52e" "0574c520-6942-11ed-a917-43299f97bee6" "dk9r294wvfwkgvhn"
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

        var urlRequest = URLRequest(url: url, httpMethod: httpMethod)

        urlRequest.allHTTPHeaderFields = headers

        if isNeedIdentifier {
            urlRequest.setValue(APIConstants.identifier, forHTTPHeaderField: "identifier")
        }
        print(urlRequest.description)
        return urlRequest
    }
}

enum EndPoint: RequestProtocol {
    case list(page: Int, itemPerPage: Int = 20)
    case post

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
        switch self {
        case .list(_, _):
            return HTTPMethod.get
        case .post:
            return HTTPMethod.post
        }
    }

    var headers: [String: String] {
        switch self {
        case .list(_, _):
            return [:]
        case .post:
            return ["Content-Type" : "multipart/form-data; boundary=\(Multipart.boundaryValue)"]
        }
    }

    var isNeedIdentifier: Bool {
        switch self {
        case .list(_, _):
            return false
        default:
            return true
        }
    }
}
