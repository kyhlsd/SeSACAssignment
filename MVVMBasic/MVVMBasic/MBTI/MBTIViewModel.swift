//
//  MBTIViewModel.swift
//  MVVMBasic
//
//  Created by 김영훈 on 8/11/25.
//

import Foundation

final class MBTIViewModel {
    let mbti = Observable(["", "", "", ""])
    
    let mbtiCases = MBTI.allCases
    
    private var isAllSelected = false
    
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
                isAllSelected = false
                return
            }
        }
        isAllSelected = true
    }
}
