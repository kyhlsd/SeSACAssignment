//
//  Tamagotchi.swift
//  Tamagotchi
//
//  Created by 김영훈 on 8/23/25.
//

import Foundation

struct Tamagotchi: Codable {
    var type: TamagotchiType
    var meal: Int
    var water: Int
    
    var level: Int {
        let score = Int(Float(meal) / 5 + Float(water) / 2)
        var level = score / 10
        level = min(10, level)
        level = max(1, level)
        return level
    }
    
    var description: String {
        return "LV\(level) · 밥알 \(meal)개 · 물방울 \(water)개"
    }
    
    var image: String {
        if type == .unready {
            return type.image
        } else {
            return type.image + String(level)
        }
    }
}

enum TamagotchiType: String, CaseIterable, Codable {
    case tingling = "따끔따끔 다마고치"
    case smailing = "방실방실 다마고치"
    case twinkling = "반짝반짝 다마고치"
    case unready = "준비중이에요"
    
    var image: String {
        switch self {
        case .tingling:
            return "1-"
        case .smailing:
            return "2-"
        case .twinkling:
            return "3-"
        case .unready:
            return "noImage"
        }
    }
    
    var defaultImage: String {
        if self == .unready {
            return self.image
        } else {
            return self.image + "6"
        }
    }
    
    var introduce: String {
        return """
               저는 \(self.rawValue)입니다.
               열심히 잘 먹고 잘 클 자신 있습니다.
               """
    }
}
