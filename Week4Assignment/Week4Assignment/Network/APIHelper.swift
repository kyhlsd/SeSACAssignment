//
//  APIHelper.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/24/25.
//

import Foundation
import Alamofire

enum MovieAPIHelper {
    static let originURL = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/search"
    static func getURL(type: apiType, targetDate: String) -> String {
        let apiKey = (Bundle.main.object(forInfoDictionaryKey: "MOVIE_API_KEY") as? String) ?? "nilKey"
        let url = originURL + type.rawValue + ".json?key=" + apiKey + "&targetDt=" + targetDate
        return url
    }
    enum apiType: String {
        case daily = "DailyBoxOfficeList"
        case weekly = "WeeklyBoxOfficeList"
    }
}

enum LottoAPIHelper {
    static let originURL = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo="
    static func getURL(targetRound: Int) -> String {
        return originURL + "\(targetRound)"
    }
}

enum ShoppingAPIHelper {
    static let originURL = "https://openapi.naver.com/v1/search/shop.json?query="
    static func getURL(query: String) -> String {
        return originURL + query
    }
    static let headers: HTTPHeaders = [
        "X-Naver-Client-Id": (Bundle.main.object(forInfoDictionaryKey: "X_NAVER_CLIENT_ID") as? String) ?? "nilId",
        "X-Naver-Client-Secret": (Bundle.main.object(forInfoDictionaryKey: "X_NAVER_CLIENT_SECRET") as? String) ?? "nilSecret"
    ]
}
