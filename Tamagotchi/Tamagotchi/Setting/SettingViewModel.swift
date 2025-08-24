//
//  SettingViewModel.swift
//  Tamagotchi
//
//  Created by 김영훈 on 8/25/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SettingViewModel {
    
    enum SettingType: String, CaseIterable {
        case username = "내 이름 설정하기"
        case tamagotchi = "다마고치 변경하기"
        case reset = "데이터 초기화"
        
        var icon: String {
            switch self {
            case .username:
                return "pencil"
            case .tamagotchi:
                return "moon.fill"
            case .reset:
                return "arrow.clockwise"
            }
        }
    }
    
    struct Input {
        let cellTap: ControlEvent<SettingType>
        let resetData: PublishRelay<Void>
    }
    
    struct Output {
        let list: Observable<[SettingType]>
        let resetAlert: PublishRelay<Void>
        let transitionToRootVC: PublishRelay<Void>
    }
    
    let username = UserDefaultManager.shared.username
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let resetAlert: PublishRelay<Void> = PublishRelay()
        let transitionToRootVC: PublishRelay<Void> = PublishRelay()
        
        input.cellTap
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .bind { type in
                switch type {
                case .username:
                    print("username")
                case .tamagotchi:
                    print("tamagotchi")
                case .reset:
                    resetAlert.accept(())
                }
            }
            .disposed(by: disposeBag)
        
        input.resetData
            .bind(with: self) { owner, _ in
                owner.resetData()
                transitionToRootVC.accept(())
            }
            .disposed(by: disposeBag)
        
        let list = Observable.just(SettingType.allCases)
        return Output(list: list, resetAlert: resetAlert, transitionToRootVC: transitionToRootVC)
    }
    
    private func resetData() {
        UserDefaultManager.shared.resetData()
    }
}
