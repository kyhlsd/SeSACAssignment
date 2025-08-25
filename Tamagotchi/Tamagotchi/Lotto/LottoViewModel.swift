//
//  LottoViewModel.swift
//  Tamagotchi
//
//  Created by 김영훈 on 8/25/25.
//

import Foundation
import RxSwift
import RxCocoa

final class LottoViewModel {
    
    struct Input {
        let searchButtonClick: Observable<String>
    }
    
    struct Output {
        let result: PublishRelay<Lotto>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let result = PublishRelay<Lotto>()
        
        input.searchButtonClick
            .distinctUntilChanged()
            .compactMap { Int($0) }
            .flatMap { round in
                APIObservable.callRequest(url: .getLotto(targetRound: round), type: Lotto.self) }
            .subscribe { value in
                result.accept(value)
            } onError: { error in
                print(error)
            }
            .disposed(by: disposeBag)
        
        return Output(result: result)
    }
}
