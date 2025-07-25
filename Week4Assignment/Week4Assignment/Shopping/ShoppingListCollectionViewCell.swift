//
//  ShoppingListCollectionViewCell.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/25/25.
//

import UIKit
import SnapKit
import Kingfisher

class ShoppingListCollectionViewCell: UICollectionViewCell, Identifying {
    
    private let imageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private let favoriteButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.clipsToBounds = true
        return button
    }()
    
    private let mallLabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let priceLabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViewDesign()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureData(with shoppingItem: ShoppingItem) {
        let url = URL(string: shoppingItem.image)
        imageView.kf.setImage(with: url, options: [
            .processor(DownsamplingImageProcessor(size: CGSize(width: 100, height: 100))),
            .scaleFactor(UIScreen.main.scale),
            .cacheOriginalImage
        ])
        
        mallLabel.text = shoppingItem.mallName
        titleLabel.text = shoppingItem.title
        priceLabel.text = shoppingItem.lprice
    }
}

extension ShoppingListCollectionViewCell: ViewDesignProtocol {
    func configureHierarchy() {
        [imageView, favoriteButton, mallLabel, titleLabel, priceLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.bottom.trailing.equalTo(imageView).inset(8)
        }
        
        mallLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(imageView).inset(8)
            make.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(mallLabel)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(mallLabel)
            make.bottom.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    
    func configureView() {
//        backgroundColor = .clear
//        contentView.backgroundColor = .clear
    }
}
