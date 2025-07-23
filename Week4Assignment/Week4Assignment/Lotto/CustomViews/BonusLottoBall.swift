//
//  BonusLottoBall.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/23/25.
//

import UIKit
import SnapKit

final class BonusLottoBall: UIView {
    private let lottoBall: LottoBall
    private let label = {
        let label = UILabel()
        label.text = "보너스"
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    init(number: Int) {
        self.lottoBall = LottoBall(number: number)
        super.init(frame: .zero)
        
        addSubview(lottoBall)
        addSubview(label)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        lottoBall.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.top.equalTo(lottoBall.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(lottoBall)
            make.bottom.equalToSuperview()
        }
    }
}
