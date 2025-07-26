//
//  SortOptions.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/25/25.
//

import Foundation

enum SortOption: String, CaseIterable {
    case accuracy = "정확도"
    case date = "날짜순"
    case highPrice = "가격높은순"
    case lowPrice = "가격낮은순"
    
    var queryString: String {
        switch self {
        case .accuracy:
            return "sim"
        case .date:
            return "date"
        case .highPrice:
            return "dsc"
        case .lowPrice:
            return "asc"
        }
    }
}
