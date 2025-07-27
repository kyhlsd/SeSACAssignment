//
//  LottoAPIManager.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/27/25.
//

import Foundation
import Alamofire

struct LottoAPIManager {
    static let shared = LottoAPIManager()
    private init() {}
    
    private let originURL = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo="
    private func getURL(targetRound: Int) -> String {
        return originURL + "\(targetRound)"
    }
    
    func fetchData(targetRound: Int, successHandler: @escaping (LottoResult)->(), failureHandler: @escaping (AFError)->()) {
        let url = getURL(targetRound: targetRound)
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: LottoResult.self) { response in
                switch response.result {
                case .success(let value):
                    successHandler(value)
                case .failure(let error):
                    failureHandler(error)
                }
            }

    }
}
