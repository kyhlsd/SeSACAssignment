//
//  AgeViewModel.swift
//  MVVMBasic
//
//  Created by 김영훈 on 8/8/25.
//

import Foundation

final class AgeViewModel {
    var inputText = Observable("")
    var age = Observable(0)
    var errorMessage = Observable("")
    
    init() {
        inputText.bind { _ in
            self.setAge()
        }
    }
    
    private func setAge() {
        do {
            age.value = try getValidAge(inputText.value)
        } catch {
            errorMessage.value = "나이는 " + error.errorMessage
        }
    }
    
    private func getValidAge(_ text: String?) throws(InputValidationError) -> Int {
        let trimmed = try InputValidationHelper.getTrimmedText(text)
        let number = try InputValidationHelper.convertTypeFromText(trimmed, type: Int.self)
        try InputValidationHelper.validateRange(number, min: 1, max: 100)
        return number
    }
}
