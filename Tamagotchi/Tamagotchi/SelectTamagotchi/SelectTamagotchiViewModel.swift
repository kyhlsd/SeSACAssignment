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
        let cellTap: ControlEvent<TamagotchiType>
    }
    
    struct Output {
        let navigationTitle: String
        let list: Observable<[TamagotchiType]>
        let showAlertTrigger: PublishRelay<TamagotchiType>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let isInit = UserDefaultManager.shared.tamagotchi.value.type == .unready
        let navigationTitle = isInit ? "다마고치 선택하기" : "다마고치 변경하기"
        let types = TamagotchiType.allCases
        let unreadys = [TamagotchiType](repeating: .unready, count: 20 - types.count)
        let list = Observable.just(types + unreadys)
        
        let showAlertTrigger: PublishRelay<TamagotchiType> = PublishRelay()
        
        input.cellTap
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .filter { $0 != .unready }
            .bind(to: showAlertTrigger)
            .disposed(by: disposeBag)
        
        return Output(navigationTitle: navigationTitle, list: list, showAlertTrigger: showAlertTrigger)
    }
}
