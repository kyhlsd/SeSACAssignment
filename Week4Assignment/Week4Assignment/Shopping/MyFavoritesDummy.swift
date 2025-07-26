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
    static func toggleItemInFavorites(productId: String) {
        if let index = items.firstIndex(of: productId) {
            items.remove(at: index)
        } else {
            items.append(productId)
        }
    }
}
