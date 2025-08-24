//
//  InsetLabel.swift
//  Tamagotchi
//
//  Created by 김영훈 on 8/24/25.
//

import UIKit

final class InsetLabel: UILabel {
    var edgeInsets: UIEdgeInsets = .init(top: 2.0, left: 4.0, bottom: 2.0, right: 4.0)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: edgeInsets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        
        return CGSize(width: size.width + edgeInsets.left + edgeInsets.right, height: size.height + edgeInsets.top + edgeInsets.bottom)
    }
    
    override var bounds: CGRect {
        didSet {
            preferredMaxLayoutWidth = bounds.width - (edgeInsets.left + edgeInsets.right)
        }
    }
}
