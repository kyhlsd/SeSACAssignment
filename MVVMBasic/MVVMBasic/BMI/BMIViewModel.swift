//
//  BMIViewModel.swift
//  MVVMBasic
//
//  Created by 김영훈 on 8/8/25.
//

import Foundation

final class BMIViewModel {
    
    var inputTexts = PhysicalInputs(height: nil, weight: nil) {
        didSet {
            calculateBMI(height: inputTexts.height, weight: inputTexts.weight)
        }
    }
    
    var succuessHandler: ((Double) -> Void)?
    var failureHandler: ((String) -> Void)?
    
    private var bmi = 0.0 {
        didSet {
            succuessHandler?(bmi)
        }
    }
    
    private var errorMessage = "" {
        didSet {
            failureHandler?(errorMessage)
        }
    }
    
    private func getValidNumber(_ text: String?, min: Double, max: Double) throws(InputValidationError) -> Double {
        let trimmed = try InputValidationHelper.getTrimmedText(text)
        let number = try InputValidationHelper.convertTypeFromText(trimmed, type: Double.self)
        try InputValidationHelper.validateRange(number, min: min, max: max)
        return number
    }
    
    private func calculateBMI(height: String?, weight: String?) {
        var wrongField = "키는 "
        do {
            // height : m , weight : kg 기준
            let height = try getValidNumber(height, min: 100, max: 300) / 100
            wrongField = "몸무게는 "
            let weight = try getValidNumber(weight, min: 20, max: 250)
            
            bmi = weight / (height * height)
        } catch {
            errorMessage = wrongField + error.errorMessage
        }
    }
    
}
