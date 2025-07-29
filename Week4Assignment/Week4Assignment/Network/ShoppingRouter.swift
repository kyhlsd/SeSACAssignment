//
//  ShoppingRouter.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/29/25.
//

import Foundation
import Alamofire

enum ShoppingRouter: URLRequestConvertible {
    case getItems(searchText: String, display: Int, sortOption: SortOption, start: Int)
    
    var baseURL: URL {
        guard let url = URL(string: "https://openapi.naver.com/v1/search/shop.json?") else {
            fatalError("baseURL Error") }
        return url
    }
    
    var method: HTTPMethod {
        return .get
    }

    var parameters: Parameters? {
        return nil
    }
    
    var paths: String {
        switch self {
        case .getItems(let searchText, let display, let sortOption, let start):
            return "query=\(searchText)&display=\(display)&sort=\(sortOption.queryString)&start=\(start)"
        }
    }
    
    var headers: HTTPHeaders {
        return [
            "X-Naver-Client-Id": (Bundle.main.object(forInfoDictionaryKey: "X_NAVER_CLIENT_ID") as? String) ?? "nilId",
            "X-Naver-Client-Secret": (Bundle.main.object(forInfoDictionaryKey: "X_NAVER_CLIENT_SECRET") as? String) ?? "nilSecret"
        ]
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(paths))
        urlRequest.method = method
        urlRequest.headers = headers
        if let parameters {
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        }
        return urlRequest
    }
}

class ShoppingAPIService {
    static let shared = ShoppingAPIService()
    
    private init() {}
    
    func fetchData(searchText: String, display: Int = 100, sortOption: SortOption = .accuracy, start: Int = 1, successHandler: @escaping (ShoppingResult) -> (), failureHandler: @escaping (NaverAPIError) -> ()) {
        let url = ShoppingRouter.getItems(searchText: searchText, display: display, sortOption: sortOption, start: start)
        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ShoppingResult.self) { response in
                switch response.result {
                case .success(let value):
                    successHandler(value)
                case .failure(let error):
                    if let data = response.data, let naverServerError = try? JSONDecoder().decode(NaverServerError.self, from: data) {
                        failureHandler(NaverAPIError.server(naverServerError))
                    } else {
                        failureHandler(NaverAPIError.network(error))
                    }
                }
            }
    }
}
