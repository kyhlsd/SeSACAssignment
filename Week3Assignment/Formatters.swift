//
//  Formatters.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/14/25.
//

import Foundation

enum IntToDemicalStringFormatter {
    static let formatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}

enum DateStringFormatter {
    static let yyMMddFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyMMdd"
        return formatter
    }()
    static let koreanFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일"
        return formatter
    }()
}

