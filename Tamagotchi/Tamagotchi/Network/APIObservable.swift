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
    static func callRequest<T: Decodable> (url: Router, type: T.Type = T.self) -> Observable<T> {
        return Observable<T>.create { observer in
            AF.request(url).responseDecodable(of: type) { response in
                switch response.result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
