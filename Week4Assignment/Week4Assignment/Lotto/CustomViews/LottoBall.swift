//
//  LottoBallLabel.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/23/25.
//

import UIKit
import SnapKit

final class LottoBall: UILabel {
    private var number: Int
    
    init(number: Int) {
        self.number = number
        super.init(frame: .zero)
        
        setBackgroundColor()
        configureLabel()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = frame.height / 2
        super.draw(rect)
    }
    
    private func configureLabel() {
        setLabel()
        textColor = .white
        textAlignment = .center
        clipsToBounds = true
    }
    
    private func configureLayout() {
        snp.makeConstraints { make in
            make.height.equalTo(self.snp.width)
        }
    }
    
    func setNumber(number: Int) {
        self.number = number
        setLabel()
        setBackgroundColor()
    }
    
    private func setLabel() {
        if number < 1 || number > 45 {
            text = "E"
        } else {
            text = String(number)
        }
    }
    
    private func setBackgroundColor() {
        switch number {
        case 1..<10:
            backgroundColor = .systemYellow
        case 10..<20:
            backgroundColor = .systemCyan
        case 20..<30:
            backgroundColor = .systemPink
        case 30..<40:
            backgroundColor = .systemGray
        case 40...45:
            backgroundColor = .systemGreen
        default:
            backgroundColor = .black
        }
    }
}
