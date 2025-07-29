//
//  MovieRouter.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/29/25.
//

import Foundation
import Alamofire

enum MovieRouter: Router {
    case getDailyItems(targetDate: String)
    case getWeeklyItems(targetDate: String)
    
    var baseURL: URL {
        var urlString = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/search"
        switch self {
        case .getDailyItems:
            urlString += "DailyBoxOfficeList.json"
        case .getWeeklyItems:
            urlString += "WeeklyBoxOfficeList.json"
        }
        
        guard let url = URL(string: urlString) else {
            fatalError("baseURL Error")
        }
        return url
    }
    
    var method: HTTPMethod {
        switch self {
        case .getDailyItems:
            return .get
        case .getWeeklyItems:
            return .get
        }
    }
    
    var paths: String? {
        return nil
    }
    
    var queryItems: [URLQueryItem] {
        let apiKey = (Bundle.main.object(forInfoDictionaryKey: "MOVIE_API_KEY") as? String) ?? "nilKey"
        switch self {
        case .getDailyItems(let targetDate):
            return [
                URLQueryItem(name: "key", value: apiKey),
                URLQueryItem(name: "targetDt", value: targetDate),
            ]
        case .getWeeklyItems(let targetDate):
            return [
                URLQueryItem(name: "key", value: apiKey),
                URLQueryItem(name: "targetDt", value: targetDate),
            ]
        }
    }
    
    var headers: HTTPHeaders {
        return [:]
    }
    
    var parameters: Parameters? {
        return nil
    }
}
