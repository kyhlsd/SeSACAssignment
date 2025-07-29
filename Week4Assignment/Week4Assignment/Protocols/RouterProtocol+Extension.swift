//
//  RouterProtocol+Extension.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/29/25.
//

import Foundation
import Alamofire

protocol Router: URLRequestConvertible {
    var baseURL: URL { get }
    var method: HTTPMethod { get }
    var paths: String? { get }
    var queryItems: [URLQueryItem] { get }
    var headers: HTTPHeaders { get }
    var parameters: Parameters? { get }
    func asURLRequest() throws -> URLRequest
}

extension Router {
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
