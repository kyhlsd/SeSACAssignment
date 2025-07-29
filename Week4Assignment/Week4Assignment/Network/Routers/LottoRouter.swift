//
//  LottoRouter.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/29/25.
//

import Foundation
import Alamofire

enum LottoRouter: Router {
    case getItem(targetRound: Int)
    
    var baseURL: URL {
        guard let url = URL(string: "https://www.dhlottery.co.kr/common.do") else {
            fatalError("baseURL Error") }
        return url
    }
    
    var method: HTTPMethod {
        switch self {
        case .getItem(_):
            return .get
        }
    }
    
    var paths: String? {
        switch self {
        case .getItem(_):
            return nil
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .getItem(let targetRound):
            return [
                URLQueryItem(name: "method", value: "getLottoNumber"),
                URLQueryItem(name: "drwNo", value: String(targetRound))
            ]
        }
    }
    
    var headers: HTTPHeaders {
        return [:]
    }
    
    var parameters: Parameters? {
        return nil
    }
}
