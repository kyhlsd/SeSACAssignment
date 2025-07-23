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
}
