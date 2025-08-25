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
    case getMovie(targetDate: String)
    
    var baseURL: String {
        switch self {
        case .getLotto(_):
            return APIInfo.Lotto.url
        case .getMovie(_):
            return APIInfo.Movie.url
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getLotto(_):
            return .get
        case .getMovie(_):
            return .get
        }
    }
    
    var paths: String? {
        switch self {
        case .getLotto(_):
            return nil
        case .getMovie(_):
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
        case .getMovie(targetDate: let targetDate):
            return [
                URLQueryItem(name: "key", value: APIInfo.Movie.key),
                URLQueryItem(name: "targetDt", value: targetDate)
            ]
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .getLotto(_):
            return nil
        case .getMovie(_):
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
