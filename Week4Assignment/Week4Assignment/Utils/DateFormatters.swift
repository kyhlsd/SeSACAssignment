//
//  DateFormatters.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/23/25.
//

import Foundation

enum DateFormatters {
    static let yyMMddDashFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "yy-MM-dd"
        return formatter
    }()
    
    static let yyyyMMddFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()
    
    static let yyyyMMddDashFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static func getConvertedDateString(from fromFormatter: DateFormatter, to toFormatter: DateFormatter, dateString: String) -> String? {
        guard let date = fromFormatter.date(from: dateString) else { return nil}
        
        return toFormatter.string(from: date)
    }
}
