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
    var items: [ShoppingItem]
}

struct ShoppingItem: Decodable {
    let title: String
    let image: String
    let productId: String
    let mallName: String
    let lprice: Int
    
    enum CodingKeys: CodingKey {
        case title
        case image
        case productId
        case mallName
        case lprice
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.image = try container.decode(String.self, forKey: .image)
        self.productId = try container.decode(String.self, forKey: .productId)
        self.mallName = try container.decode(String.self, forKey: .mallName)
        
        let lpriceString = try container.decode(String.self, forKey: .lprice)
        self.lprice = Int(lpriceString) ?? -1
    }
}
