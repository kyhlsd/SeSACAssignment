//
//  MainViewModel.swift
//  Week7Assignment
//
//  Created by 김영훈 on 8/13/25.
//

import Foundation

final class MainViewModel {
    
    var input: Input
    var output: Output
    
    struct Input {
        let profile = Observable<Profile?>(nil)
    }
    
    struct Output {
        let profileInfo = Observable(("", ""))
    }
    
    init() {
        input = Input()
        output = Output()
        
        input.profile.bind { _ in
            self.setProfileInfo()
        }
    }
    
    private func setProfileInfo() {
        let profile = input.profile.value
        let nickname = profile?.nickname ?? "없음"
        let mbti = profile?.mbti.mbtiString ?? "없음"
        let description = "닉네임: \(nickname)\nMBTI: \(mbti)"
        let image = profile?.image ?? ""
        
        output.profileInfo.value = (description, image)
    }
}
