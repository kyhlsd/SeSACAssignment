//
//  APIHelper.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/24/25.
//

import Foundation

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

