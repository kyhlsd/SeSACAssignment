//
//  AgeViewModel.swift
//  MVVMBasic
//
//  Created by 김영훈 on 8/8/25.
//

import Foundation

final class AgeViewModel {
    var inputText: String? {
        didSet {
            setAge()
        }
    }
    
    var succuessHandler: (() -> Void)?
    var failureHandler: ((String) -> Void)?
    
    private var age: Int = 0 {
        didSet {
            succuessHandler?()
        }
    }
    
    private var errorMessage = "" {
        didSet {
            failureHandler?(errorMessage)
        }
    }
    
    private func setAge() {
        do {
            age = try getValidAge(inputText)
        } catch {
            errorMessage = "나이는 " + error.errorMessage
        }
    }
    
    private func getValidAge(_ text: String?) throws(InputValidationError) -> Int {
        let trimmed = try InputValidationHelper.getTrimmedText(text)
        let number = try InputValidationHelper.convertTypeFromText(trimmed, type: Int.self)
        try InputValidationHelper.validateRange(number, min: 1, max: 100)
        return number
    }
}
