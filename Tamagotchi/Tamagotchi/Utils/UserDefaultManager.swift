//
//  UserDefaultManager.swift
//  Tamagotchi
//
//  Created by 김영훈 on 8/24/25.
//

import Foundation
import RxSwift
import RxCocoa

final class UserDefaultManager {
    static let shared = UserDefaultManager()
    private init() {}
    
    private static let disposeBag = DisposeBag()
    
    let tamagotchi = {
        let key = "Tamagotchi"
        let data = {
            guard let data = UserDefaults.standard.data(forKey: key),
                  let decoded = try? PropertyListDecoder().decode(Tamagotchi.self, from: data) else { return Tamagotchi(type: .unready, meal: 0, water: 0) }
            return decoded
        }()

        let behaviorRelay = BehaviorRelay(value: data)
        behaviorRelay
            .bind { value in
                UserDefaults.standard.set(try? PropertyListEncoder().encode(value), forKey: key)
            }
            .disposed(by: UserDefaultManager.disposeBag)
        return behaviorRelay
    }()
    
    @UserDefault(key: "Username", defaultValue: "대장")
    var username: String
    
    func resetData() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
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
