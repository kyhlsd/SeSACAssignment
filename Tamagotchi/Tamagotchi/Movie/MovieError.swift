//
//  MovieError.swift
//  Tamagotchi
//
//  Created by 김영훈 on 8/26/25.
//

import Foundation

enum MovieError: LocalizedError {
    case invalidFormat
    case invalidRange(min: Date, max: Date)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidFormat:
            return "적절한 닐짜 형식이 아닙니다. ex) 20250825"
        case .invalidRange(let min, let max):
            let formatter = MovieDateFormatter.dateFormatter
            let min = formatter.string(from: min)
            let max = formatter.string(from: max)
            return "\(min) ~ \(max) 만 검색 가능합니다."
        case .unknown:
            return "알 수 없는 에러가 발생했습니다."
        }
    }
}
