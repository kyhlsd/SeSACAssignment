//
//  RouterProtocol.swift
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
