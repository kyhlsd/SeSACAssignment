//
//  CurrencyViewModel.swift
//  MVVMBasic
//
//  Created by 김영훈 on 8/8/25.
//

import Foundation

final class CurrencyViewModel {
    var inputText = Observable("")
    var convertedAmount = Observable(0.0)
    var errorMessage = Observable("")
    
    private let exchangeRate = 1350.0
    
    init() {
        inputText.bind { _ in
            self.calculateExchange()
        }
    }
    
    private func calculateExchange() {
        do {
            let amount = try getValidAmountFromText()
            convertedAmount.value = amount / exchangeRate
        } catch {
            errorMessage.value = "올바른 금액을 입력해주세요."
        }
    }
    
    private func getValidAmountFromText() throws(InputValidationError) -> Double {
        let trimmed = try InputValidationHelper.getTrimmedText(inputText.value)
        let amount = try InputValidationHelper.convertTypeFromText(trimmed, type: Double.self)
        return amount
    }
}
