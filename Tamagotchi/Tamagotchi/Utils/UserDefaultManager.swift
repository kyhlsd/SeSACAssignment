//
//  UserDefaultManager.swift
//  Tamagotchi
//
//  Created by 김영훈 on 8/24/25.
//

import Foundation

enum UserDefaultManager {
    @UserDefaultForModel(key: "Tamagotchi", defaultValue: nil)
    static var tamagotchi: Tamagotchi?
}

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T?
    
    var wrappedValue: T? {
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
    let defaultValue: T?
    
    var wrappedValue: T? {
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
