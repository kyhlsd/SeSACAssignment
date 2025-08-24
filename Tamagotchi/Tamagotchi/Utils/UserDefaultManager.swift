//
//  UserDefaultManager.swift
//  Tamagotchi
//
//  Created by 김영훈 on 8/24/25.
//

import Foundation

enum UserDefaultManager {
    @UserDefaultForModel(key: "Tamagotchi", defaultValue: Tamagotchi(type: .unready, meal: 0, water: 0))
    static var tamagotchi: Tamagotchi
    
    @UserDefault(key: "Username", defaultValue: "대장")
    static var username: String
}

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

@propertyWrapper
struct UserDefaultForModel<T: Codable> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            if let data = UserDefaults.standard.data(forKey: key),
               let decoded = try? PropertyListDecoder().decode(T.self, from: data) {
                return decoded
            }
            return defaultValue
        }
        set {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: key)
        }
    }
}
