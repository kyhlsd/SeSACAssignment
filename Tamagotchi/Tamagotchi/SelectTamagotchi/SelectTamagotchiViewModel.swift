//
//  SelectTamagotchiViewModel.swift
//  Tamagotchi
//
//  Created by 김영훈 on 8/23/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SelectTamagotchiViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        let list: Observable<[TamagotchiType]>
    }
    
    func transform(input: Input) -> Output {
        let types = TamagotchiType.allCases
        let unreadys = [TamagotchiType](repeating: .unready, count: 20 - types.count)
        let list = Observable.just(types + unreadys)
        
        return Output(list: list)
    }
}
