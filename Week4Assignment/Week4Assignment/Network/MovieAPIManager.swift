//
//  MovieAPIManager.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/24/25.
//

import Foundation
import Alamofire

struct MovieAPIManager {
    static let shared = MovieAPIManager()
    private init() {}
    
    private let originURL = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/search"
    private func getURL(type: APIType, targetDate: String) -> String {
        let apiKey = (Bundle.main.object(forInfoDictionaryKey: "MOVIE_API_KEY") as? String) ?? "nilKey"
        let url = originURL + type.rawValue + ".json?key=" + apiKey + "&targetDt=" + targetDate
        return url
    }
    enum APIType: String {
        case daily = "DailyBoxOfficeList"
        case weekly = "WeeklyBoxOfficeList"
    }
    
    func fetchData(targetDate: String, type: APIType = .daily, successHandler: @escaping (BoxOfficeResult)->(), failureHandler: @escaping (AFError)->()) {
        let url = getURL(type: type, targetDate: targetDate)
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: BoxOfficeResult.self) { response in
                switch response.result {
                case .success(let value):
                    successHandler(value)
                case .failure(let error):
                    failureHandler(error)
                }
            }
    }
}
