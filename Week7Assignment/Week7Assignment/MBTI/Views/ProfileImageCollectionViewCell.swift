//
//  ProfileImageCollectionViewCell.swift
//  Week7Assignment
//
//  Created by 김영훈 on 8/13/25.
//

import UIKit
import SnapKit

final class ProfileImageCollectionViewCell: UICollectionViewCell, Identifying {
    
    private let imageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        imageView.layer.cornerRadius = imageView.frame.height / 2
    }
    
    func configureData(_ image: String, isSelected: Bool = false) {
        imageView.image = UIImage(named: image)
        
        if isSelected {
            imageView.layer.borderColor = UIColor.enabledButton.cgColor
            imageView.layer.borderWidth = 4
            imageView.alpha = 1
        } else {
            imageView.layer.borderColor = UIColor.disabledButton.cgColor
            imageView.layer.borderWidth = 2
            imageView.alpha = 0.5
        }
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
