//
//  APIHelper.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/24/25.
//

import Foundation

enum MovieAPIInfo {
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

