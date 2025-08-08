//
//  CurrencyViewModel.swift
//  MVVMBasic
//
//  Created by 김영훈 on 8/8/25.
//

import Foundation

final class CurrencyViewModel {
    var inputText: String? {
        didSet {
            calculateExchange()
        }
    }

    var updateView: ((String) -> Void)?
    
    private let exchangeRate = 1350.0
    
    private var message = "" {
        didSet {
            updateView?(message)
        }
    }
    
    private func calculateExchange() {
        do {
            let amount = try getValidAmountFromText()
            let convertedAmount = amount / exchangeRate
            message = String(format: "%.2f USD (약 $%.2f)", convertedAmount, convertedAmount)
        } catch {
            message = "올바른 금액을 입력해주세요."
        }
    }
    
    private func getValidAmountFromText() throws(InputValidationError) -> Double {
        let trimmed = try InputValidationHelper.getTrimmedText(inputText)
        let amount = try InputValidationHelper.convertTypeFromText(trimmed, type: Double.self)
        return amount
    }
}
