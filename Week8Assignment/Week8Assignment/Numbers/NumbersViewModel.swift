//
//  NumbersViewModel.swift
//  Week8Assignment
//
//  Created by 김영훈 on 8/23/25.
//

import Foundation
import RxSwift
import RxCocoa

final class NumbersViewModel {
    
    struct Input {
        let firstText: ControlProperty<String>
        let secondText: ControlProperty<String>
        let thirdText: ControlProperty<String>
    }
    
    struct Output {
        let result: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        let result = Observable.combineLatest(input.firstText, input.secondText, input.thirdText) { first, second, third -> Int in
            return (Int(first) ?? 0) + (Int(second) ?? 0) + (Int(third) ?? 0)
            }
            .map { $0.description }
        let output = Output(result: result)
        return output
    }
}
