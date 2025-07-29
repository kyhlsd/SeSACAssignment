//
//  ShoppingRouter.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/29/25.
//

import Foundation
import Alamofire

enum ShoppingRouter: Router {
    case getItems(searchText: String, display: Int, sortOption: SortOption, start: Int)
    
    var baseURL: URL {
        guard let url = URL(string: "https://openapi.naver.com/v1/search/shop.json") else {
            fatalError("baseURL Error") }
        return url
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var paths: String? {
        switch self {
        case .getItems(_, _, _, _):
            return nil
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .getItems(let searchText, let display, let sortOption, let start):
            return [
                URLQueryItem(name: "query", value: searchText),
                URLQueryItem(name: "display", value: display.formatted()),
                URLQueryItem(name: "sort", value: sortOption.queryString),
                URLQueryItem(name: "start", value: start.formatted()),
            ]
        }
    }
    
    var headers: HTTPHeaders {
        return [
            "X-Naver-Client-Id": (Bundle.main.object(forInfoDictionaryKey: "X_NAVER_CLIENT_ID") as? String) ?? "nilId",
            "X-Naver-Client-Secret": (Bundle.main.object(forInfoDictionaryKey: "X_NAVER_CLIENT_SECRET") as? String) ?? "nilSecret"
        ]
    }
    
    var parameters: Parameters? {
        return nil
    }
    
    func asURLRequest() throws -> URLRequest {
        var url = try baseURL.asURL()
        if let paths { url = url.appendingPathComponent(paths) }
        url = url.appending(queryItems: queryItems)

        var urlRequest = URLRequest(url: url)
        urlRequest.method = method
        urlRequest.headers = headers
        if let parameters {
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        }
        return urlRequest
    }
}
