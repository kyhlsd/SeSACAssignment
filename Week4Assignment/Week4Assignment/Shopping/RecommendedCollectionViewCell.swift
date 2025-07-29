//
//  RecommendedCollectionViewCell.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/29/25.
//

import UIKit
import SkeletonView
import Kingfisher

class RecommendedCollectionViewCell: UICollectionViewCell, Identifying {
    private let imageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.kf.indicatorType = .activity
        return imageView
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray4
        label.numberOfLines = 2
        return label
    }()
    
    private let priceLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViewDesign()
        
        configureSkeleton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSkeleton() {
        isSkeletonable = true
        imageView.isSkeletonable = true
        titleLabel.isSkeletonable = true
        priceLabel.isSkeletonable = true
        
        titleLabel.linesCornerRadius = 4
        priceLabel.linesCornerRadius = 4
    }
    
    func configureData(with shoppingItem: ShoppingItem) {
        let url = URL(string: shoppingItem.image)
        imageView.kf.setImage(with: url, options: [
            .processor(DownsamplingImageProcessor(size: CGSize(width: 80, height: 80))),
            .scaleFactor(UIScreen.main.scale),
            .cacheOriginalImage
        ])
        
        DispatchQueue.main.async {
            self.titleLabel.text = shoppingItem.title.htmlDecodedString
        }
        
        priceLabel.text = shoppingItem.lprice.formatted()
    }
}

extension RecommendedCollectionViewCell: ViewDesignProtocol {
    func configureHierarchy() {
        [imageView, titleLabel, priceLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(imageView).inset(4)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges.equalTo(titleLabel)
            make.bottom.lessThanOrEqualToSuperview()
            make.height.equalTo(18)
        }
    }
    
    func configureView() { contentView.backgroundColor = .yellow }
}
