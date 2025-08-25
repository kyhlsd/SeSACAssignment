//
//  Movie.swift
//  Tamagotchi
//
//  Created by 김영훈 on 8/25/25.
//

import Foundation

struct Movie: Decodable {
    let boxOfficeResult: BoxOfficeResult
}

struct BoxOfficeResult: Decodable {
    let boxOfficeType: String
    let showRange: String
    let dailyBoxOfficeList: [BoxOffice]
    
    enum CodingKeys: String, CodingKey {
        case boxOfficeType = "boxofficeType"
        case showRange
        case dailyBoxOfficeList
    }
}

struct BoxOffice: Decodable {
    let name: String
    let openDate: String
    let rank: Int
    
    enum CodingKeys: String, CodingKey {
        case name = "movieNm"
        case openDate = "openDt"
        case rank
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.openDate = try container.decode(String.self, forKey: .openDate)
        
        let rankString = try container.decode(String.self, forKey: .rank)
        guard let rank = Int(rankString) else {
            throw DecodingError.dataCorruptedError(forKey: .rank, in: container, debugDescription: "Rank string does not match format")
        }
        self.rank = rank
    }
}


