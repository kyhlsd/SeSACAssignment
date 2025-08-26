//
//  MovieDateFormatter.swift
//  Tamagotchi
//
//  Created by 김영훈 on 8/26/25.
//

import Foundation

enum MovieDateFormatter {
    static let dateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()
}
