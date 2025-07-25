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
    static let yyyyMMddHHmmDashFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()
    static let yyMMddDotFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        return formatter
    }()
    static let koreanTimeFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "HH:mm a"
        return formatter
    }()
    
    static func getConvertedDateString(from fromFormatter: DateFormatter, to toFormatter: DateFormatter, dateString: String?) -> String? {
        guard let dateString else { return nil }
        
        if let date = fromFormatter.date(from: dateString) {
            return toFormatter.string(from: date)
        } else {
            return nil
        }
    }
}

