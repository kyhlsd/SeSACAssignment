//
//  MBTICollectionViewCell.swift
//  MVVMBasic
//
//  Created by 김영훈 on 8/11/25.
//

import UIKit
import SnapKit

final class MBTICollectionViewCell: UICollectionViewCell, Identifying {
    private let label = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.textAlignment = .center
        label.layer.borderWidth = 1
        label.clipsToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        label.layer.cornerRadius = label.frame.height / 2
    }
    
    func configureCell(_ text: String, isSelected: Bool) {
        label.text = text
        
        if isSelected {
            label.textColor = .white
            label.backgroundColor = .enabledButton
            label.layer.borderColor = UIColor.enabledButton.cgColor
        } else {
            label.textColor = .disabledButton
            label.backgroundColor = .white
            label.layer.borderColor = UIColor.disabledButton.cgColor
        }
    }
    
    private func setup() {
        contentView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
}
