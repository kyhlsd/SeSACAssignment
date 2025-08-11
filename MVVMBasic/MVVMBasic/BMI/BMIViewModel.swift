//
//  BMIViewModel.swift
//  MVVMBasic
//
//  Created by 김영훈 on 8/8/25.
//

import Foundation

final class BMIViewModel {
    
    var inputTexts = Observable(PhysicalInputs(height: nil, weight: nil))
    var bmi = Observable(0.0)
    var errorMessage = Observable("")
    var isInitial = true
    
    init() {
        inputTexts.bind { _ in
            self.calculateBMI()
        }
    }
    
    private func getValidNumber(_ text: String?, min: Double, max: Double) throws(InputValidationError) -> Double {
        let trimmed = try InputValidationHelper.getTrimmedText(text)
        let number = try InputValidationHelper.convertTypeFromText(trimmed, type: Double.self)
        try InputValidationHelper.validateRange(number, min: min, max: max)
        return number
    }
    
    private func calculateBMI() {
        var wrongField = "키는 "
        do {
            // height : m , weight : kg 기준
            let height = try getValidNumber(inputTexts.value.height, min: 100, max: 300) / 100
            wrongField = "몸무게는 "
            let weight = try getValidNumber(inputTexts.value.weight, min: 20, max: 250)
            
            bmi.value = weight / (height * height)
        } catch {
            errorMessage.value = wrongField + error.errorMessage
        }
    }
    
}
