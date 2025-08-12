//
//  SearchShoppingViewModel.swift
//  Week4Assignment
//
//  Created by 김영훈 on 8/12/25.
//

import Foundation

final class SearchShoppingViewModel {
    
    let inputSearchBarText = Observable<String?>(nil)
    
    let outputSearchTrigger = Observable("")
    let outputAlertTrigger = Observable(("", ""))
    
    init() {
        inputSearchBarText.bind { _ in
            self.validateSearchBarText()
        }
    }
    
    private func validateSearchBarText() {
        let trimmed = inputSearchBarText.value?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if trimmed.count >= 2 {
            outputSearchTrigger.value = trimmed
        } else {
            outputAlertTrigger.value = ("검색 오류", "검색어를 2자 이상 입력해주세요.")
        }
    }
}
