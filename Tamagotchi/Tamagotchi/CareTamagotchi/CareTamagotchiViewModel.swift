//
//  CareTamagotchiViewModel.swift
//  Tamagotchi
//
//  Created by 김영훈 on 8/24/25.
//

import Foundation
import RxSwift
import RxCocoa

final class CareTamagotchiViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        let navigationTitle: BehaviorRelay<String>
        let bubbleMessage: BehaviorRelay<String>
        let tamagotchi: BehaviorRelay<Tamagotchi>
        let description: BehaviorRelay<String>
    }
    
    private let bubbleMessages = [
        "\(UserDefaultManager.username)님, 안녕하세요\n좀 쉬셔야겠어요",
        "\(UserDefaultManager.username)님,\n소고기가 먹고 싶어요",
        "\(UserDefaultManager.username)님,\n집 청소를 하셔야해요"
    ]
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let navigationTitle = BehaviorRelay(value: "\(UserDefaultManager.username)님의 다마고치")
        let bubbleMessage = BehaviorRelay(value: bubbleMessages.randomElement() ?? "")
        let tamagotchi = BehaviorRelay(value: UserDefaultManager.tamagotchi)
        let description = BehaviorRelay(value: "")
        tamagotchi
            .map { $0.description }
            .bind(to: description)
            .disposed(by: disposeBag)
        return Output(navigationTitle: navigationTitle, bubbleMessage: bubbleMessage, tamagotchi: tamagotchi, description: description)
    }
}
