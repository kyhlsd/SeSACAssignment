//
//  MBTI.swift
//  MVVMBasic
//
//  Created by 김영훈 on 8/11/25.
//

import Foundation

struct MBTI {
    let first: First
    let second: Second
    let thrid: Third
    let fourth: Fourth
    
    static let allCases = {
        let first = MBTI.First.allCases.map { $0.rawValue }
        let second = MBTI.Second.allCases.map { $0.rawValue }
        let third = MBTI.Third.allCases.map { $0.rawValue }
        let fourth = MBTI.Fourth.allCases.map { $0.rawValue }
        return [first, second, third, fourth]
    }()
    
    enum First: String, CaseIterable {
        case e = "E"
        case i = "I"
    }
    enum Second: String, CaseIterable {
        case s = "S"
        case n = "N"
    }
    enum Third: String, CaseIterable {
        case t = "T"
        case f = "F"
    }
    enum Fourth: String, CaseIterable {
        case j = "J"
        case p = "P"
    }
}
