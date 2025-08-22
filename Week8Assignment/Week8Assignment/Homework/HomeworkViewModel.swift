//
//  HomeworkViewModel.swift
//  Week8Assignment
//
//  Created by 김영훈 on 8/22/25.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeworkViewModel {
    
    struct Input {
        let tableViewCellTap: ControlEvent<Person>
        let searchButtonClick: Observable<ControlProperty<String>.Element>
    }
    
    struct Output {
        let userList: BehaviorRelay<[Person]>
        let tappedList: BehaviorRelay<[String]>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let userList = BehaviorRelay(value: Person.dummy)
        let tappedList = BehaviorRelay(value: [String]())
        
        input.tableViewCellTap
            .map { $0.name }
            .bind { name in
                tappedList.accept([name] + tappedList.value)
            }
            .disposed(by: disposeBag)
        
        input.searchButtonClick
            .map { text in
                Person(name: text, email: "email@email.com", profileImage: "")
            }
            .bind { person in
                userList.accept([person] + userList.value)
            }
            .disposed(by: disposeBag)
        
        let output = Output(userList: userList, tappedList: tappedList)
        return output
    }
}
