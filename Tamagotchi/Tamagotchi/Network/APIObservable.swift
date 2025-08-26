//
//  APIObservable.swift
//  Tamagotchi
//
//  Created by 김영훈 on 8/25/25.
//

import Foundation
import Alamofire
import RxSwift

enum APIObservable {
    static func callRequest<T: Decodable> (url: Router, type: T.Type = T.self) -> Single<Result<T, Error>> {
        return Single.create { observer in
            AF.request(url).responseDecodable(of: type) { response in
                switch response.result {
                case .success(let value):
                    observer(.success(.success(value)))
                case .failure(let error):
                    observer(.success(.failure(error)))
                }
            }
            return Disposables.create()
        }
    }
}
