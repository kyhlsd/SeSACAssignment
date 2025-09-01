//
//  LottoViewModel.swift
//  Tamagotchi
//
//  Created by 김영훈 on 8/25/25.
//

import Foundation
import RxSwift
import RxCocoa

final class LottoViewModel {
    
    struct Input {
        let searchButtonClick: Observable<String>
    }
    
    struct Output {
        let lottoResult: PublishRelay<Lotto>
        let errorToastMessage: PublishRelay<String>
        let networkAlert: PublishRelay<(String, String)>
    }
    
    private let disposeBag = DisposeBag()
    private var prevSucceed = true
    
    func transform(input: Input) -> Output {
        let lottoResult = PublishRelay<Lotto>()
        let errorToastMessage = PublishRelay<String>()
        let networkAlert = PublishRelay<(String, String)>()
        let callRequestTrigger = PublishRelay<Int>()
        input.searchButtonClick
            .throttle(.milliseconds(250), scheduler: MainScheduler.instance)
            .flatMap { [weak self] in
                guard let self else { return Single<Result<Int, LottoError>>.just(.failure(.unknown))}
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
            .flatMap {
                APIObservable.callRequest(url: .getLotto(targetRound: $0), type: Lotto.self)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let lotto):
                    lottoResult.accept(lotto)
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
        
        return Output(lottoResult: lottoResult, errorToastMessage: errorToastMessage, networkAlert: networkAlert)
    }
    
    private func validate(_ text: String) -> Single<Result<Int, LottoError>> {
        return Single.create { [weak self] observer in
            guard let self else {
                observer(.success(.failure(LottoError.unknown)))
                return Disposables.create()
            }
            do {
                let number = try transformToInt(text)
                let round = try validateRange(number)
                observer(.success(.success(round)))
            } catch let error as LottoError {
                observer(.success(.failure(error)))
            } catch {
                observer(.success(.failure(LottoError.unknown)))
            }
            return Disposables.create()
        }
    }
    
    private func transformToInt(_ text: String) throws(LottoError) -> Int {
        let pattern = "^[0-9]+$"
        if let _ = text.range(of: pattern, options: .regularExpression) {
            print("+x")
        }
        
        let pattern2 = /[0-9]+[.][0-9]+/
        if let _ = text.wholeMatch(of: pattern2) {
            print("+x.x")
        }
        
        let pattern3 = /[$^*]/
        if let _ = text.firstMatch(of: pattern3) {
            print("contains $^*")
        }
        
        
        
        if let transformed = Int(text) {
            return transformed
        } else {
            throw .nonInteger
        }
    }
    
    private func validateRange(_ number: Int) throws(LottoError) -> Int {
        let current = 1186
        if number < 1 || number > current {
            throw .invalidRange(maxRound: current)
        } else {
            return number
        }
    }
}
