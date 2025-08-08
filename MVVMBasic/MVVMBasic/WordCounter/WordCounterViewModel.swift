//
//  WordCounterViewModel.swift
//  MVVMBasic
//
//  Created by 김영훈 on 8/8/25.
//

import Foundation

final class WordCounterViewModel {
    var inputText: String? {
        didSet {
            calculateCount()
        }
    }
    
    var updateView: ((Int) -> Void)?
    
    private var textCount = 0 {
        didSet {
            updateView?(textCount)
        }
    }
    
    private func calculateCount() {
        textCount = (inputText ?? "").count
    }
}
