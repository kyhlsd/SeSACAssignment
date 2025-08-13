//
//  ProfileSettingViewModel.swift
//  MVVMBasic
//
//  Created by 김영훈 on 8/11/25.
//

import Foundation

final class ProfileSettingViewModel {
    var inputNickname = Observable("")
    private(set) var nicknameStatusText = Observable(" ")
    private(set) var isEnableNickname = Observable(false)
    private(set) var validNickname = ""
    
    let mbti = Observable(["", "", "", ""])
    private var isAllSelected = Observable(false)
    let mbtiCases = MBTI.allCases
    
    private(set) var isEnableComplete = Observable(false)
    
    init() {
        inputNickname.bind { _ in
            self.validateNickname()
        }
        isAllSelected.bind { _ in
            self.updateIsEnableComplete()
        }
    }
    
    private func updateIsEnableComplete() {
        isEnableComplete.value = isEnableNickname.value && isAllSelected.value
    }
    
    private func validateNickname() {
        do {
            let trimmed = try InputValidationHelper.getTrimmedText(inputNickname.value)
            try InputValidationHelper.validateRange(trimmed.count, min: 2, minAllowsEqual: true, max: 10, maxAllowsEqual: false)
            try InputValidationHelper.validateContainNumber(trimmed)
            try InputValidationHelper.validateSpecialChar(trimmed, specialChars: ["@", "#", "$", "%"])
            nicknameStatusText.value = "사용할 수 있는 닉네임이에요."
            isEnableNickname.value = true
            validNickname = trimmed
        } catch let error as InputValidationError {
            var errorMessage = error.errorMessage
            if errorMessage == InputValidationError.emptyText.errorMessage { errorMessage = " " }
            nicknameStatusText.value = errorMessage
            isEnableNickname.value = false
        } catch {
            nicknameStatusText.value = error.localizedDescription
            isEnableNickname.value = false
        }
        updateIsEnableComplete()
    }
    
    func getIsSelected(indexPath: IndexPath) -> Bool {
        return mbti.value[indexPath.section] == mbtiCases[indexPath.section][indexPath.item]
    }
    
    func selectMBTI(indexPath: IndexPath) {
        mbti.value[indexPath.section] = mbtiCases[indexPath.section][indexPath.item]
        updateIsAllSelected()
    }
    
    private func updateIsAllSelected() {
        for item in mbti.value {
            if item.isEmpty {
                isAllSelected.value = false
                return
            }
        }
        isAllSelected.value = true
    }
}
