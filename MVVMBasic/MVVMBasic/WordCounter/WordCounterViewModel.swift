//
//  WordCounterViewModel.swift
//  MVVMBasic
//
//  Created by 김영훈 on 8/8/25.
//

import Foundation

final class WordCounterViewModel {
    
    var inputText = Observable("")
    var textCount = Observable(0)
    
    init() {
        inputText.bind { _ in
            self.calculateCount()
        }
    }
    
    private func calculateCount() {
        textCount.value = inputText.value.count
    }
}
