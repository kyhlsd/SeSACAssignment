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
}
