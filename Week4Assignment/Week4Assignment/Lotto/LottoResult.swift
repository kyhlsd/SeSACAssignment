//
//  LottoResult.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/24/25.
//

import Foundation

struct LottoResult: Decodable {
    let date: String
    let numbers: [Int]
    let bonusNumber: Int
    let round: Int
    
    enum CodingKeys: String, CodingKey {
        case date = "drwNoDate"
        case number1 = "drwtNo1"
        case number2 = "drwtNo2"
        case number3 = "drwtNo3"
        case number4 = "drwtNo4"
        case number5 = "drwtNo5"
        case number6 = "drwtNo6"
        case bonusNumber = "bnusNo"
        case round = "drwNo"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try container.decode(String.self, forKey: .date)
        self.bonusNumber = try container.decode(Int.self, forKey: .bonusNumber)
        self.round = try container.decode(Int.self, forKey: .round)
        
        var numbers = [Int]()
        for i in 1...6 {
            guard let key = LottoResult.CodingKeys(rawValue: "drwtNo\(i)") else {
                throw DecodingError.dataCorruptedError(forKey: .number1 , in: container, debugDescription: "Number does not match format")
            }
            numbers.append(try container.decode(Int.self, forKey: key))
        }
        self.numbers = numbers
    }
}
