//
//  Shopping.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/25/25.
//

import Foundation

struct ShoppingResult: Decodable {
    let total: Int
    let start: Int
    let display: Int
    let items: [ShoppingItem]
}

struct ShoppingItem: Decodable {
    let title: String
    let image: String
    let productId: String
}
