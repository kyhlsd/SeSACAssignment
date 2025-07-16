//
//  CALayer+Extension.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/16/25.
//

import UIKit

extension CALayer {
    func setRightBottomShadow(shadowOpacity: Float = 0.7, shadowColor: UIColor = .gray, shadowRadius: CGFloat = 4) {
        self.shadowOpacity = shadowOpacity
        self.shadowColor = shadowColor.cgColor
        self.shadowRadius = shadowRadius
        self.shadowOffset = CGSize(width: shadowRadius, height: shadowRadius)
        self.masksToBounds = false
    }
}
