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
        let errorToastMessage: PublishRelay<String>
        let networkAlert: PublishRelay<(String, String)>
    }
    
    private let disposeBag = DisposeBag()
    private var prevSucceed = true
    
    func transform(input: Input) -> Output {
        let movieResult = PublishRelay<Movie>()
        let errorToastMessage = PublishRelay<String>()
        let networkAlert = PublishRelay<(String, String)>()
        
        input.searchButtonClick
            .compactMap { [weak self] in
                self?.validate($0, to: errorToastMessage)
            }
            .distinctUntilChanged{ [weak self] in
                guard let self else { return true }
                guard self.prevSucceed else { return false }
                return $0 == $1
            }
            .flatMap { date in
                APIObservable.callRequest(url: .getMovie(targetDate: date), type: Movie.self)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let movie):
                    movieResult.accept(movie)
                    owner.prevSucceed = true
                case .failure(let error):
                    switch error {
                    case .network:
                        networkAlert.accept(("네트워크 단절", error.localizedDescription))
                    case .unknown(_):
                        errorToastMessage.accept(error.localizedDescription)
                    }
                    owner.prevSucceed = false
                }
            }
            .disposed(by: disposeBag)
        
        return Output(movieResult: movieResult, errorToastMessage: errorToastMessage, networkAlert: networkAlert)
    }
    
    private func validate(_ text: String, to errorToastMessage: PublishRelay<String>) -> String? {
        do {
            let date = try validateIsValidFormat(text)
            let dateString = try validateRange(date)
            return dateString
        } catch {
            errorToastMessage.accept(error.localizedDescription)
            return nil
        }
    }
    
    private func validateIsValidFormat(_ text: String) throws(MovieError) -> Date {
        let formatter = MovieDateFormatter.dateFormatter
        if let date = formatter.date(from: text) {
            return date
        } else {
            throw .invalidFormat
        }
    }
    
    private func validateRange(_ date: Date) throws(MovieError) -> String {
        let formatter = MovieDateFormatter.dateFormatter
        let min = formatter.date(from: "20000101")!
        let max = Calendar.current.date(byAdding: .day, value: -1, to: Date())!

        if min > date || max < date {
            throw .invalidRange(min: min, max: max)
        }
        return formatter.string(from: date)
    }
}
