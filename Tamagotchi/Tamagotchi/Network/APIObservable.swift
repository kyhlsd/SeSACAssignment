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
    static func callRequest<T: Decodable> (url: Router, type: T.Type = T.self) -> Single<Result<T, APIError>> {
        return Single.create { observer in
            
            if !NetworkMonitor.shared.isConnected {
                observer(.success(.failure(APIError.network)))
                return Disposables.create()
            }
            
            AF.request(url).responseDecodable(of: type) { response in
                switch response.result {
                case .success(let value):
                    observer(.success(.success(value)))
                case .failure(_):
                    var description: String?
                    if let data = response.data {
                        description = String(data: data, encoding: .utf8)
                    }
                    observer(.success(.failure(APIError.unknown(description: description))))
                }
            }
            return Disposables.create()
        }
    }
}
