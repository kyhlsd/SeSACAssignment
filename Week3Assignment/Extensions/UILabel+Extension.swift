//
//  UILabel+Extension.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/17/25.
//

import UIKit

extension UILabel {
    func setAttributedTextlWithKeyword(text: String, keyword: String, pointColor: UIColor) {
        let range = (text as NSString).range(of: keyword, options: .caseInsensitive)
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: pointColor, range: range)
        attributedText = attributedString
    }
}
