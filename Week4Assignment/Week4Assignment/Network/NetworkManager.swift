//
//  NetworkManager.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/29/25.
//

import Foundation
import Alamofire

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    private var currentRequest: DataRequest?
    
    func fetchData<T: Decodable>(url: URLRequestConvertible, type: T.Type, successHandler: @escaping (T) -> Void, failureHandler: @escaping (APIError) -> Void) {
        currentRequest?.cancel()
        
        currentRequest = AF.request(url)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: type) { response in
                switch response.result {
                case .success(let value):
                    successHandler(value)
                case .failure(let error):
                    if let data = response.data {
                        failureHandler(APIError.server(data))
                    } else {
                        failureHandler(APIError.network(error))
                    }
                }
            }
    }
}
