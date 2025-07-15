//
//  UIView+Extension.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/15/25.
//

import UIKit

extension UIView {
    func setCornerRadius(corners: CACornerMask, cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = corners
        clipsToBounds = true
    }
    
    func setRightBottomShadow(shadowOpacity: Float = 0.7, shadowColor: UIColor = .gray, shadowRadius: CGFloat = 4) {
        layer.shadowOpacity = shadowOpacity
        layer.shadowColor = shadowColor.cgColor
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = CGSize(width: shadowRadius, height: shadowRadius)
        layer.masksToBounds = false
    }
}
