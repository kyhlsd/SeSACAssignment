//
//  NumberFormatters.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/25/25.
//

import Foundation

enum NumberFormatters {
    static let demicalFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}
