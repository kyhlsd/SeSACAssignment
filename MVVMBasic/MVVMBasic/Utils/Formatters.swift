//
//  Formatters.swift
//  MVVMBasic
//
//  Created by 김영훈 on 8/7/25.
//

import Foundation

enum Formatters {
    enum NumberFormatters {
        static let twoDemicalFormatter = {
           let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            return formatter
        }()
    }
    enum DateFormatters {
        static let yyyyMMddFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd"
            return formatter
        }()
    }
}
