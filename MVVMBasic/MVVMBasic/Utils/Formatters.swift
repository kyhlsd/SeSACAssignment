//
//  Formatters.swift
//  MVVMBasic
//
//  Created by 김영훈 on 8/7/25.
//

import Foundation

enum Formatters {
    enum DateFormatters {
        static let yyyyMMddFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd"
            return formatter
        }()
    }
}
