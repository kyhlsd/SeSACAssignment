//
//  MovieServerError.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/29/25.
//

import Foundation

struct MovieServerError: Decodable {
    let faultInfo: MovieFaultInfo
}

struct MovieFaultInfo: Decodable {
    let message: String
    let errorCode: String
}
