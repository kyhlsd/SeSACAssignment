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
    
    func transform(input: Input) -> Output {
        let lottoResult = PublishRelay<Lotto>()
        let errorToastMessage = PublishRelay<String>()
        let networkAlert = PublishRelay<(String, String)>()
        
        input.searchButtonClick
            .distinctUntilChanged()
            .compactMap { [weak self] in
                self?.validate($0, to: errorToastMessage)
            }
            .flatMap {
                APIObservable.callRequest(url: .getLotto(targetRound: $0), type: Lotto.self) }
            .bind { result in
                switch result {
                case .success(let lotto):
                    lottoResult.accept(lotto)
                case .failure(let error):
                    switch error {
                    case .network:
                        networkAlert.accept(("네트워크 단절", error.localizedDescription))
                    case .unknown(_):
                        errorToastMessage.accept(error.localizedDescription)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        return Output(lottoResult: lottoResult, errorToastMessage: errorToastMessage, networkAlert: networkAlert)
    }
    
    private func validate(_ text: String, to errorToastMessage: PublishRelay<String>) -> Int? {
        do {
            let number = try transformToInt(text)
            let round = try validateRange(number)
            return round
        } catch {
            errorToastMessage.accept(error.localizedDescription)
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
