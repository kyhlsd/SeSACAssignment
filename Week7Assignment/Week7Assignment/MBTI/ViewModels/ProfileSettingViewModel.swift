//
//  ProfileSettingViewModel.swift
//  MVVMBasic
//
//  Created by 김영훈 on 8/11/25.
//

import Foundation

protocol ProfileImageTransferDelegate: AnyObject {
    func setProfileImage(image: String)
}


final class ProfileSettingViewModel {
    
    var input: Input
    var output: Output
    
    struct Input {
        let nickname = Observable<String?>(nil)
        let selectMBTITrigger = Observable<IndexPath?>(nil)
        let completeButtonTrigger = Observable(())
    }
    
    struct Output {
        let nicknameStatusText = Observable(" ")
        let isEnableNickname = Observable(false)
        let mbti = Observable(["", "", "", ""])
        let isEnableComplete = Observable(false)
        let profileImage = Observable("person\(Int.random(in: 0..<12))")
        let convertRootVCTrigger = Observable<Profile?>(nil)
    }
    
    var validNickname = ""
    private var mbtiAllSelected = false
    let mbtiCases = MBTI.allCases
    
    init() {
        input = Input()
        output = Output()
        
        input.nickname.bind { _ in
            self.validateNickname()
        }
        
        input.selectMBTITrigger.bind { indexPath in
            guard let indexPath else { return }
            
            self.output.mbti.value[indexPath.section] = self.mbtiCases[indexPath.section][indexPath.item]
            self.updateIsAllSelected()
        }
        
        input.completeButtonTrigger.bind { _ in
            self.makeProfile()
        }
    }
    
    private func updateIsEnableComplete() {
        output.isEnableComplete.value = output.isEnableNickname.value && mbtiAllSelected
    }
    
    private func validateNickname() {
        do {
            let trimmed = try InputValidationHelper.getTrimmedText(input.nickname.value)
            try InputValidationHelper.validateRange(trimmed.count, min: 2, minAllowsEqual: true, max: 10, maxAllowsEqual: false)
            try InputValidationHelper.validateContainNumber(trimmed)
            try InputValidationHelper.validateSpecialChar(trimmed, specialChars: ["@", "#", "$", "%"])
            output.nicknameStatusText.value = "사용할 수 있는 닉네임이에요."
            output.isEnableNickname.value = true
            validNickname = trimmed
        } catch let error as InputValidationError {
            var errorMessage = error.errorMessage
            if errorMessage == InputValidationError.emptyText.errorMessage { errorMessage = " " }
            output.nicknameStatusText.value = errorMessage
            output.isEnableNickname.value = false
        } catch {
            output.nicknameStatusText.value = error.localizedDescription
            output.isEnableNickname.value = false
        }
        updateIsEnableComplete()
    }
    
    private func updateIsAllSelected() {
        for item in output.mbti.value {
            if item.isEmpty {
                mbtiAllSelected = false
                updateIsEnableComplete()
                return
            }
        }
        mbtiAllSelected = true
        updateIsEnableComplete()
    }
    
    private func makeProfile() {
        guard let nickname = input.nickname.value else { return }
        let profileImage = output.profileImage.value
        
        let first = MBTI.First(rawValue: output.mbti.value[0])
        let second = MBTI.Second(rawValue: output.mbti.value[1])
        let third = MBTI.Third(rawValue: output.mbti.value[2])
        let fourth = MBTI.Fourth(rawValue: output.mbti.value[3])
        
        guard let first, let second, let third, let fourth else { return }
        let mbti = MBTI(first: first, second: second, third: third, fourth: fourth)
        
        let profile = Profile(nickname: nickname, mbti: mbti, image: profileImage)
        
        output.convertRootVCTrigger.value = profile
    }
    
    func getIsSelected(indexPath: IndexPath) -> Bool {
        return output.mbti.value[indexPath.section] == mbtiCases[indexPath.section][indexPath.item]
    }
}

extension ProfileSettingViewModel: ProfileImageTransferDelegate {
    func setProfileImage(image: String) {
        output.profileImage.value = image
    }
}
