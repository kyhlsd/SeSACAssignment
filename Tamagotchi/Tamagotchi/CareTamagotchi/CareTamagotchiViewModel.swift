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
        let profileButtonTap: ControlEvent<Void>
        let mealButtonTap: Observable<String?>
        let waterButtonTap: Observable<String?>
        let updateBubble: PublishRelay<Void>
    }
    
    struct Output {
        let navigationTitle: BehaviorRelay<String>
        let bubbleMessage: PublishRelay<String>
        let tamagotchi: BehaviorRelay<Tamagotchi>
        let toastMessage: PublishRelay<String>
    }
    
    private let bubbleMessages = [
        "\(UserDefaultManager.username)님, 안녕하세요\n좀 쉬셔야겠어요",
        "\(UserDefaultManager.username)님,\n소고기가 먹고 싶어요",
        "\(UserDefaultManager.username)님,\n집 청소를 하셔야해요"
    ]
    private let maxMealForOnce = 99
    private let maxWaterForOnce = 49
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let navigationTitle = BehaviorRelay(value: "\(UserDefaultManager.username)님의 다마고치")
        let bubbleMessage: PublishRelay<String> = PublishRelay()
        let tamagotchi = BehaviorRelay(value: UserDefaultManager.tamagotchi)
        let toastMessage: PublishRelay<String> = PublishRelay()
        
        input.updateBubble
            .compactMap { [weak self] in
                self?.bubbleMessages.randomElement()
            }
            .bind(to: bubbleMessage)
            .disposed(by: disposeBag)
        
        input.mealButtonTap
            .compactMap { [weak self] in
                self?.transformToInt($0, toast: toastMessage)
            }
            .compactMap { [weak self] value -> Int? in
                guard let self else { return nil }
                return self.validateInt(value, max: self.maxMealForOnce, toast: toastMessage)
            }
            .bind { number in
                var tempTamagotchi = tamagotchi.value
                tempTamagotchi.meal += number
                tamagotchi.accept(tempTamagotchi)
                
                input.updateBubble.accept(())
            }
            .disposed(by: disposeBag)
        
        input.waterButtonTap
            .compactMap { [weak self] in
                self?.transformToInt($0, toast: toastMessage)
            }
            .compactMap { [weak self] value -> Int? in
                guard let self else { return nil }
                return self.validateInt(value, max: self.maxWaterForOnce, toast: toastMessage)
            }
            .bind { number in
                var tempTamagotchi = tamagotchi.value
                tempTamagotchi.water += number
                tamagotchi.accept(tempTamagotchi)
                
                input.updateBubble.accept(())
            }
            .disposed(by: disposeBag)
        
        tamagotchi
            .bind {
                UserDefaultManager.tamagotchi = $0
            }
            .disposed(by: disposeBag)
        
        return Output(navigationTitle: navigationTitle, bubbleMessage: bubbleMessage, tamagotchi: tamagotchi, toastMessage: toastMessage)
    }
    
    private func transformToInt(_ text: String?, toast: PublishRelay<String>) -> Int? {
        let trimmed = text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if trimmed.isEmpty {
            return 1
        }
        
        let number = Int(trimmed)
        if number == nil {
            toast.accept("자연수를 입력해주세요")
        }
        return number
    }
    
    private func validateInt(_ number: Int, max: Int, toast: PublishRelay<String>) -> Int? {
        if number < 1 || number > max {
            toast.accept("1 이상 \(max)이하 수를 입력하세요")
            return nil
        }
        return number
    }
}
