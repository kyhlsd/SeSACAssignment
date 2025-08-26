//
//  NamingViewModel.swift
//  Tamagotchi
//
//  Created by 김영훈 on 8/25/25.
//

import Foundation
import RxSwift
import RxCocoa

final class NamingViewModel {
    
    struct Input {
        let saveButtonTap: Observable<String>
    }
    
    struct Output {
        let username: Observable<String>
        let toastMessage: PublishRelay<String>
        let popVC: PublishRelay<Void>
    }
    
    private let disposeBag = DisposeBag()
    private let maxCount = 6
    private let minCount = 2
    
    func transform(input: Input) -> Output {
        let userName = Observable.just(UserDefaultManager.shared.username.value)
        let toastMessage: PublishRelay<String> = PublishRelay()
        let popVC: PublishRelay<Void> = PublishRelay()
        input.saveButtonTap
            .compactMap { [weak self] in
                self?.validateName($0, toast: toastMessage)
            }
            .distinctUntilChanged()
            .bind {
                UserDefaultManager.shared.username.accept($0)
                popVC.accept(())
            }
            .disposed(by: disposeBag)
        return Output(username: userName, toastMessage: toastMessage, popVC: popVC)
    }
    
    private func validateName(_ text: String, toast: PublishRelay<String>) -> String? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.count < minCount || trimmed.count > maxCount {
            toast.accept("\(minCount)자 이상 \(maxCount)자 이하로 입력해주세요")
            return nil
        }
        toast.accept("이름이 변경되었습니다.")
        return trimmed
    }
}
