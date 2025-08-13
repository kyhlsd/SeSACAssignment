//
//  NaverServerError.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/29/25.
//

import Foundation

struct NaverServerError: Decodable {
    let errorMessage: String
    let errorCode: String
}
