//
//  TextValidateHelper.swift
//  MVVMBasic
//
//  Created by 김영훈 on 8/7/25.
//

import Foundation

enum TextValidateError: Error {
    case nilText
    case emptyText
    case nonNumeric
    case invalidRange(min: Double, minAllowsEqual: Bool = true, max: Double, maxAllowsEqual: Bool = true)
    
    var errorMessage: String {
        switch self {
        case .nilText:
            return "텍스트가 nil 입니다."
        case .emptyText:
            return "텍스트가 비었습니다."
        case .nonNumeric:
            return "텍스트는 숫자만 입력할 수 있습니다."
        case .invalidRange(let min, let minAllowsEqual, let max, let maxAllowsEqual):
            let minWord = minAllowsEqual ? "이상" : "초과"
            let maxWord = maxAllowsEqual ? "이하" : "미만"
            let message = "텍스트는 " + min.formatted() + minWord + " " + max.formatted() + maxWord + " 수만 입력 가능합니다."
            return message
        }
    }
}

enum TextValidateHelper {
    static func getTrimmedText(_ text: String?) throws(TextValidateError) -> String {
        guard let text else { throw .nilText }
        
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    static func getNumber(_ text: String?) throws(TextValidateError) -> Double {
        let trimmed = try getTrimmedText(text)
        
        guard let number = Double(trimmed) else { throw .nonNumeric }
        return number
    }
    
    static func validateIsEmpty(_ text: String?) throws(TextValidateError) {
        let trimmed = try getTrimmedText(text)
        if trimmed.isEmpty { throw .emptyText }
    }
    
    static func validateRange(_ text: String?, min: Double, minAllowsEqual: Bool = true, max: Double, maxAllowsEqual: Bool = true) throws(TextValidateError) {
        
        let number = try getNumber(text)
        
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
