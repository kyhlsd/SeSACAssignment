//
//  LottoError.swift
//  Tamagotchi
//
//  Created by 김영훈 on 8/26/25.
//

import Foundation

enum LottoError: LocalizedError {
    case nonInteger
    case invalidRange(maxRound: Int)
    
    var errorDescription: String? {
        switch self {
        case .nonInteger:
            return "정수만 입력 가능합니다."
        case .invalidRange(let maxRound):
            return "1회부터 \(maxRound)회차까지만 검색 가능합니다."
        }
    }
}
