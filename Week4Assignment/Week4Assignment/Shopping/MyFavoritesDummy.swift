//
//  MyFavorites.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/25/25.
//

import Foundation

enum MyFavoritesDummy {
    static var items = [String]()
    static func isFavorite(itemId: String) -> Bool {
        return items.contains(itemId)
    }
}
