//
//  ShoppingAPIManager.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/27/25.
//

import Foundation
import Alamofire

class ShoppingAPIManager {
    static let shared = ShoppingAPIManager()
    private init() {}
    
    private let originURL = "https://openapi.naver.com/v1/search/shop.json?"
    private func getURL(searchText: String, display: Int = 100, sortOption: SortOption = .accuracy, start: Int = 1) -> String {
        return "\(originURL)query=\(searchText)&display=\(display)&sort=\(sortOption.queryString)&start=\(start)"
    }
    private let headers: HTTPHeaders = [
        "X-Naver-Client-Id": (Bundle.main.object(forInfoDictionaryKey: "X_NAVER_CLIENT_ID") as? String) ?? "nilId",
        "X-Naver-Client-Secret": (Bundle.main.object(forInfoDictionaryKey: "X_NAVER_CLIENT_SECRET") as? String) ?? "nilSecret"
    ]
    
    private var currentRequest: DataRequest?
    
    func fetchData(searchText: String, display: Int = 100, sortOption: SortOption = .accuracy, start: Int = 1, successHandler: @escaping (ShoppingResult) -> (), failureHandler: @escaping (AFError) -> ()) {
        currentRequest?.cancel()
        
        let url = getURL(searchText: searchText, display: display, sortOption: sortOption, start: start)
        
        currentRequest = AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ShoppingResult.self) { [weak self] response in
                self?.currentRequest = nil
                
                switch response.result {
                case .success(let value):
                    successHandler(value)
                case .failure(let error):
                    failureHandler(error)
                }
            }
    }
}
