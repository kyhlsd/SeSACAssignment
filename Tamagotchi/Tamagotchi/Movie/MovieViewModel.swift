//
//  MovieViewModel.swift
//  Tamagotchi
//
//  Created by 김영훈 on 8/25/25.
//

import Foundation
import RxSwift
import RxCocoa

final class MovieViewModel {
    
    struct Input {
        let searchButtonClick: Observable<String>
    }
    
    struct Output {
        let result: PublishRelay<Movie>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let result = PublishRelay<Movie>()
        
        input.searchButtonClick
            .distinctUntilChanged()
            .flatMap { date in
                APIObservable.callRequest(url: .getMovie(targetDate: date), type: Movie.self)
            }
            .subscribe { value in
                result.accept(value)
            } onError: { error in
                print(error)
            }
            .disposed(by: disposeBag)
        
        return Output(result: result)
    }
}
