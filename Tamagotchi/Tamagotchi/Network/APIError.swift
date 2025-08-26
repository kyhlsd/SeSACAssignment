//
//  APIError.swift
//  Tamagotchi
//
//  Created by 김영훈 on 8/26/25.
//

import Foundation

enum APIError: LocalizedError {
    case network
    case unknown(description: String?)
    
    var errorDescription: String? {
        switch self {
        case .network:
            return "네트워크가 연결되어 있지 않습니다."
        case .unknown(let description):
            return description ?? "알 수 없는 에러가 발생했습니다."
        }
    }
}
