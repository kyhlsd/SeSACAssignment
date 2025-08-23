//
//  SimpleValidationViewModel.swift
//  Week8Assignment
//
//  Created by 김영훈 on 8/23/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SimpleValidationViewModel {
    
    struct Input {
        let username: ControlProperty<String?>
        let password: ControlProperty<String?>
        let doSomethingButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let usernameValid: Observable<Bool>
        let passwordValid: Observable<Bool>
        let everythingValid: Observable<Bool>
        let alertTrigger: PublishRelay<Void>
    }
    
    let minimalUsernameLength = 5
    let minimalPasswordLength = 5
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let usernameValid = input.username.orEmpty
            .map { [weak self] in
                guard let self else { return false }
                return $0.count >= self.minimalUsernameLength
            }
            .share(replay: 1)
        let passwordValid = input.password.orEmpty
            .map { [weak self] in
                guard let self else { return false }
                return $0.count >= self.minimalPasswordLength
            }
            .share(replay: 1)
        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .share(replay: 1)
        let alertTrigger: PublishRelay<Void> = PublishRelay()
        
        input.doSomethingButtonTap
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .bind { _ in
                alertTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        return Output(usernameValid: usernameValid, passwordValid: passwordValid, everythingValid: everythingValid, alertTrigger: alertTrigger)
    }
}
