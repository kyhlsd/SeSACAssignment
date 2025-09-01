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
        let callRequestTrigger = PublishRelay<String>()
        
        input.searchButtonClick
            .throttle(.milliseconds(250), scheduler: MainScheduler.instance)
            .flatMap { [weak self] in
                guard let self else {
                    return Single<Result<String, MovieError>>.just(.failure(MovieError.unknown))
                }
                return self.validate($0)
            }
            .bind { result in
                switch result {
                case .success(let value):
                    callRequestTrigger.accept(value)
                case .failure(let error):
                    errorToastMessage.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        callRequestTrigger
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
    
    private func validate(_ text: String) -> Single<Result<String, MovieError>> {
        return Single<Result<String, MovieError>>.create { [weak self] observer in
            guard let self else {
                observer(.success(.failure(MovieError.unknown)))
                return Disposables.create()
            }
            
            do {
                let date = try validateIsValidFormat(text)
                let dateString = try validateRange(date)
                observer(.success(.success(dateString)))
            } catch let error as MovieError {
                observer(.success(.failure(error)))
            } catch {
                observer(.success(.failure(MovieError.unknown)))
            }
            return Disposables.create()
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
