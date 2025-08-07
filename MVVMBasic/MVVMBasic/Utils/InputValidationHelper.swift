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
    case invalidRange(min: Double, minAllowsEqual: Bool = true, max: Double, maxAllowsEqual: Bool = true)
    
    var errorMessage: String {
        switch self {
        case .emptyText:
            return "빈 값을 입력할 수 없습니다."
        case .nonNumeric:
            return "숫자만 입력할 수 있습니다."
        case .invalidRange(let min, let minAllowsEqual, let max, let maxAllowsEqual):
            let minWord = minAllowsEqual ? "이상" : "초과"
            let maxWord = maxAllowsEqual ? "이하" : "미만"
            let message = min.formatted() + minWord + " " + max.formatted() + maxWord + " 수만 입력 가능합니다."
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
    
    static func getNumber(_ text: String) throws(InputValidationError) -> Double {
        guard let number = Double(text) else { throw .nonNumeric }
        return number
    }
    
    static func validateRange(_ number: Double, min: Double, minAllowsEqual: Bool = true, max: Double, maxAllowsEqual: Bool = true) throws(InputValidationError) {
        
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
    
//    static func validateIsNumeric(_ text: String?) throws {
//        guard let text else { throw TextValidateError.emptyText }
//        
//        
//    }
    
//    static func validateTypeForNumeric<T: Numeric>(_ text: String?, type: T.Type) throws {
//        guard let text else { throw TextValidateError.emptyText }
//        
//        switch type {
//        case is Int.Type:
//            print("yes")
//        default:
//            print("no")
//        }
//    }
    
//    static func validateRange<T: Numeric>(_ text: String?, min: T, max: T) throws {
//        guard let text else { throw TextValidateError.emptyText }
//        
//        if T.self == Int.self {
//            print("yes")
//        } else {
//            print("no")
//        }
//    }
}
