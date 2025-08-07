//
//  TextValidateHelper.swift
//  MVVMBasic
//
//  Created by 김영훈 on 8/7/25.
//

import Foundation

enum InputValidationError: Error {
    case emptyText
    case nonNumeric
    case nonInteger
    case invalidRange(min: any Comparable, minAllowsEqual: Bool = true, max: any Comparable, maxAllowsEqual: Bool = true)
    
    var errorMessage: String {
        switch self {
        case .emptyText:
            return "빈 값을 입력할 수 없습니다."
        case .nonNumeric:
            return "숫자만 입력할 수 있습니다."
        case .nonInteger:
            return "정수만 입력할 수 있습니다."
        case .invalidRange(let min, let minAllowsEqual, let max, let maxAllowsEqual):
            let minWord = minAllowsEqual ? "이상" : "초과"
            let maxWord = maxAllowsEqual ? "이하" : "미만"
            let message = "\(min)\(minWord) \(max)\(maxWord)만 입력 가능합니다."
            return message
        }
    }
}

enum InputValidationHelper {
    static func getTrimmedText(_ text: String?) throws(InputValidationError) -> String {
        guard let text else { throw .emptyText }
        
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { throw .emptyText }
        
        return trimmed
    }
    
    static func getNumberFromText(_ text: String) throws(InputValidationError) -> Double {
        guard let number = Double(text) else { throw .nonNumeric }
        return number
    }
    
    static func getIntegerFromText(_ text: String) throws(InputValidationError) -> Int {
        guard let integer = Int(text) else { throw .nonInteger }
        return integer
    }
    
    static func validateRange<T: Comparable>(_ number: T, min: T, minAllowsEqual: Bool = true, max: T, maxAllowsEqual: Bool = true) throws(InputValidationError) {
        
        if number < min {
            if number != min || !minAllowsEqual {
                throw .invalidRange(min: min, minAllowsEqual: minAllowsEqual, max: max, maxAllowsEqual: maxAllowsEqual)
            }
        }

        if number > max {
            if number != max || !maxAllowsEqual {
                throw .invalidRange(min: min, minAllowsEqual: minAllowsEqual, max: max, maxAllowsEqual: maxAllowsEqual)
            }
        }
    }
}
