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
    private static let defaultTamagotchi = Tamagotchi(type: .unready, meal: 0, water: 0)
    private static let defaultUsername = "대장"
    
    let tamagotchi = {
        let key = "Tamagotchi"
        let defaultValue = defaultTamagotchi
        let data = {
            guard let data = UserDefaults.standard.data(forKey: key),
                  let decoded = try? PropertyListDecoder().decode(Tamagotchi.self, from: data) else { return defaultValue }
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
    
    let username = {
        let key = "Username"
        let defaultValue = defaultUsername
        let data = UserDefaults.standard.object(forKey: key) as? String ?? defaultValue
        let behaviorRelay = BehaviorRelay(value: data)
        behaviorRelay
            .bind { value in
                UserDefaults.standard.set(value, forKey: key)
            }
            .disposed(by: UserDefaultManager.disposeBag)
        return behaviorRelay
    }()
    
    func resetData() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
        tamagotchi.accept(UserDefaultManager.defaultTamagotchi)
        username.accept(UserDefaultManager.defaultUsername)
    }
}
