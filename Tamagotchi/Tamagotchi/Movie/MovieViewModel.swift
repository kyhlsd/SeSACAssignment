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
        let movieResult: PublishRelay<Movie>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let movieResult = PublishRelay<Movie>()
        
        input.searchButtonClick
            .distinctUntilChanged()
            .flatMap { date in
                APIObservable.callRequest(url: .getMovie(targetDate: date), type: Movie.self)
            }
            .bind { result in
                switch result {
                case .success(let movie):
                    movieResult.accept(movie)
                case .failure(let error):
                    break
                }
            }
            .disposed(by: disposeBag)
        
        return Output(movieResult: movieResult)
    }
}
