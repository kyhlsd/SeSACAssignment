//
//  TextValidateHelper.swift
//  MVVMBasic
//
//  Created by 김영훈 on 8/7/25.
//

import Foundation

enum InputValidationError: Error {
    case emptyText
    case invalidType(type: LosslessStringConvertible.Type)
    case invalidRange(min: any Comparable, minAllowsEqual: Bool = true, max: any Comparable, maxAllowsEqual: Bool = true)
    case invalidChar(chars: [Character])
    case containsNumber
    case unknown
    
    var errorMessage: String {
        switch self {
        case .emptyText:
            return "빈 값을 입력할 수 없습니다."
        case .invalidType(let type):
            switch type {
            case is Double.Type:
                return "숫자만 입력할 수 있습니다."
            case is Int.Type:
                return "정수만 입력할 수 있습니다."
            default:
                return "잘못된 타입입니다."
            }
        case .invalidRange(let min, let minAllowsEqual, let max, let maxAllowsEqual):
            let minWord = minAllowsEqual ? "이상" : "초과"
            let maxWord = maxAllowsEqual ? "이하" : "미만"
            let message = "\(min)\(minWord) \(max)\(maxWord)만 입력 가능합니다."
            return message
        case .invalidChar(let chars):
            var resultString = chars.reduce("") { $0 + "\($1), " }
            resultString.removeLast(2)
            return "\(resultString) 는 포함할 수 없습니다."
        case .containsNumber:
            return "숫자는 포함할 수 없습니다."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
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
    
    static func convertTypeFromText<T: LosslessStringConvertible>(_ text: String, type: T.Type = T.self) throws(InputValidationError) -> T {
        guard let converted = T(text) else { throw .invalidType(type: type) }
        return converted
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
    
    static func validateSpecialChar(_ text: String, specialChars: [Character]) throws {
        for specialChar in specialChars {
            if text.contains(specialChar) {
                throw InputValidationError.invalidChar(chars: specialChars)
            }
        }
    }
    
    static func validateContainNumber(_ text: String) throws {
        if let _ = text.rangeOfCharacter(from: CharacterSet.decimalDigits) {
            throw InputValidationError.containsNumber
        }
    }
}
