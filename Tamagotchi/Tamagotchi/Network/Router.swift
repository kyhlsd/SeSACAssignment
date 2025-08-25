//
//  Router.swift
//  Tamagotchi
//
//  Created by 김영훈 on 8/25/25.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    
    case getLotto(targetRound: Int)
    
    var baseURL: String {
        switch self {
        case .getLotto(_):
            return "https://www.dhlottery.co.kr/common.do"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getLotto(_):
            return .get
        }
    }
    
    var paths: String? {
        switch self {
        case .getLotto(_):
            return nil
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .getLotto(let targetRound):
            return [
                URLQueryItem(name: "method", value: "getLottoNumber"),
                URLQueryItem(name: "drwNo", value: String(targetRound)),
            ]
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .getLotto(_):
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var url = try baseURL.asURL()
        if let paths { url = url.appendingPathComponent(paths) }
        url = url.appending(queryItems: queryItems)
        let urlRequest = try URLRequest(url: url, method: method, headers: headers)
        return urlRequest
    }
}
