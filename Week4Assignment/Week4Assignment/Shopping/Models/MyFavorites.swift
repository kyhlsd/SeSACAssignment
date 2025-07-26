//
//  MyFavorites.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/25/25.
//

import Foundation

enum MyFavorites {
    @UserDefault(key: "MyFavorites", defaultValue: [])
    static var items: [String]
    
    static func isFavorite(itemId: String) -> Bool {
        return items.contains(itemId)
    }
    static func toggleItemInFavorites(itemId: String) {
        if let index = items.firstIndex(of: itemId) {
            items.remove(at: index)
        } else {
            items.append(itemId)
        }
    }
}
