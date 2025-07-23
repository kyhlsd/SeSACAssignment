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
    
    func addBorder(_ edges: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in edges {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
            default:
                break
            }
            border.backgroundColor = color.cgColor
            self.addSublayer(border)
        }
    }
}
