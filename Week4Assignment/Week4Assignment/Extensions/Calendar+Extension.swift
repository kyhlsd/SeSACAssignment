//
//  Calendar+Extension.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/24/25.
//

import Foundation

extension Calendar {
    func getDateGap(from referenceDate: Date, to targetDate: Date) -> Int {
        let referenceComponent = dateComponents([.year, .month, .day], from: referenceDate)
        let referenceOnlyDate = date(from: referenceComponent) ?? referenceDate
        
        let targetComponent = dateComponents([.year, .month, .day], from: targetDate)
        let targetOnlyDate = date(from: targetComponent) ?? targetDate
        
        let dateGap = dateComponents([.day], from: referenceOnlyDate, to: targetOnlyDate).day ?? 0
        
        return dateGap
    }
}
