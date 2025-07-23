//
//  UILabel+Extension.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/17/25.
//

import UIKit

extension UILabel {
    func setAttributedTextlWithKeyword(text: String, keyword: String, pointColor: UIColor) {
        let attributedString = NSMutableAttributedString(string: text)
        var nsText = text as NSString
        
        while true {
            let range = nsText.range(of: keyword, options: .caseInsensitive)
            if range.length == 0 {
                break
            }
            
            nsText = nsText.replacingCharacters(in: range, with: String(repeating: " ", count: range.length)) as NSString
            attributedString.addAttribute(.foregroundColor, value: pointColor, range: range)
        }
        
        attributedText = attributedString
    }
}
