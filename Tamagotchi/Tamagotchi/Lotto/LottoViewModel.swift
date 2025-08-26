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
        let lottoError: PublishRelay<Error>
    }
    
    private let disposeBag = DisposeBag()
    private let lottoError = PublishRelay<Error>()
    
    func transform(input: Input) -> Output {
        let lottoResult = PublishRelay<Lotto>()
        
        input.searchButtonClick
            .distinctUntilChanged()
            .compactMap { [weak self] in
                self?.validate($0)
            }
            .flatMap { round in
                APIObservable.callRequest(url: .getLotto(targetRound: round), type: Lotto.self) }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let lotto):
                    lottoResult.accept(lotto)
                case .failure(let error):
                    owner.lottoError.accept(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(lottoResult: lottoResult, lottoError: lottoError)
    }
    
    private func validate(_ text: String) -> Int? {
        do {
            let number = try transformToInt(text)
            let round = try validateRange(number)
            return round
        } catch {
            lottoError.accept(error)
            return nil
        }
    }
    
    private func transformToInt(_ text: String) throws(LottoError) -> Int {
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
