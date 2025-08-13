//
//  APIError.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/29/25.
//

import Foundation

enum APIError: Error {
    case network(Error)
    case server(Data)
}
