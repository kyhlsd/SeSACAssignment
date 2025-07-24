//
//  MovieError.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/24/25.
//

enum NonValidDateError: Error {
    case futureDate
    case nonDateFormat
}
