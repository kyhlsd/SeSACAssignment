//
//  SimpleTableViewModel.swift
//  Week8Assignment
//
//  Created by 김영훈 on 8/22/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SimpleTableViewModel {
    
    struct Input {
        let cellTap: ControlEvent<Int>
        let accessoryTap: ControlEvent<IndexPath>
    }
    
    struct Output {
        let list: Observable<[Int]>
        let pushVCTrigger: PublishRelay<Int>
        let alertTrigger: PublishRelay<Int>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let list = Observable.just(Array(0..<3))
        let pushVCTrigger: PublishRelay<Int> = PublishRelay()
        let alertTrigger: PublishRelay<Int> = PublishRelay()
        
        input.cellTap
            .bind { index in
                pushVCTrigger.accept(index)
            }
            .disposed(by: disposeBag)
        
        input.accessoryTap
            .map { $0.row }
            .bind { index in
                alertTrigger.accept(index)
            }
            .disposed(by: disposeBag)
        
        let output = Output(list: list, pushVCTrigger: pushVCTrigger, alertTrigger: alertTrigger)
        return output
    }
}
