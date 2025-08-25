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
        
        var displayName: String? {
            if self == .username {
                return UserDefaultManager.shared.username.value
            } else {
                return nil
            }
        }
    }
    
    struct Input {
        let cellTap: ControlEvent<SettingType>
        let resetData: PublishRelay<Void>
    }
    
    struct Output {
        let list: Observable<[SettingType]>
        let username: BehaviorRelay<String>
        let resetAlert: PublishRelay<Void>
        let pushSelectVC: PublishRelay<Void>
        let transitionToRootVC: PublishRelay<Void>
        let pushNamingVC: PublishRelay<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let list = Observable.just(SettingType.allCases)
        let username = UserDefaultManager.shared.username
        let resetAlert: PublishRelay<Void> = PublishRelay()
        let pushSelectVC: PublishRelay<Void> = PublishRelay()
        let transitionToRootVC: PublishRelay<Void> = PublishRelay()
        let pushNamingVC: PublishRelay<Void> = PublishRelay()
        
        input.cellTap
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .bind { type in
                switch type {
                case .username:
                    pushNamingVC.accept(())
                case .tamagotchi:
                    pushSelectVC.accept(())
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
        
        return Output(list: list, username: username, resetAlert: resetAlert, pushSelectVC: pushSelectVC, transitionToRootVC: transitionToRootVC, pushNamingVC: pushNamingVC)
    }
    
    private func resetData() {
        UserDefaultManager.shared.resetData()
    }
}
