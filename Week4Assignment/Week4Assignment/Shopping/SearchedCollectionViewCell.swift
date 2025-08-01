//
//  SearchedCollectionViewCell.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/25/25.
//

import UIKit
import SnapKit
import SkeletonView
import Kingfisher

class SearchedCollectionViewCell: UICollectionViewCell, Identifying {
    
    private let imageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.kf.indicatorType = .activity
        return imageView
    }()
    
    private let favoriteButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemGray2
        button.backgroundColor = .systemGray2
        button.clipsToBounds = true
        return button
    }()
    
    private let mallLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray4
        label.numberOfLines = 2
        return label
    }()
    
    private let priceLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    var shoppingItem: ShoppingItem?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViewDesign()
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonDidTapped), for: .touchUpInside)
        
        configureSkeleton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        favoriteButton.layer.cornerRadius = favoriteButton.frame.height / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        shoppingItem = nil
        imageView.image = nil
        mallLabel.text = nil
        titleLabel.text = nil
        priceLabel.text = nil
    }
    
    private func configureSkeleton() {
        isSkeletonable = true
        imageView.isSkeletonable = true
//        favoriteButton.isSkeletonable = true
        mallLabel.isSkeletonable = true
        titleLabel.isSkeletonable = true
        priceLabel.isSkeletonable = true
        
        mallLabel.linesCornerRadius = 4
        titleLabel.linesCornerRadius = 4
        priceLabel.linesCornerRadius = 4
    }
    
    func configureData() {
        guard let shoppingItem else {
            return
        }
        
        let url = URL(string: shoppingItem.image)
        imageView.kf.setImage(with: url, options: [
            .processor(DownsamplingImageProcessor(size: CGSize(width: 100, height: 100))),
            .scaleFactor(UIScreen.main.scale),
            .cacheOriginalImage
        ])
        
        setButtonImage(productId: shoppingItem.productId)
        
        mallLabel.text = shoppingItem.mallName
        
        DispatchQueue.main.async {
            self.titleLabel.text = shoppingItem.title.htmlDecodedString
        }
        
        priceLabel.text = shoppingItem.lprice.formatted()
    }
    
    @objc
    private func favoriteButtonDidTapped() {
        if let productId = shoppingItem?.productId {
            MyFavorites.toggleItemInFavorites(itemId: productId)
            setButtonImage(productId: productId)
        }
    }
    
    private func setButtonImage(productId: String) {
        let buttonImage = MyFavorites.isFavorite(itemId: productId) ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: buttonImage), for: .normal)
        favoriteButton.tintColor = .black
        favoriteButton.backgroundColor = .white
    }
}

extension SearchedCollectionViewCell: ViewDesignProtocol {
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
            make.size.equalTo(28)
            make.bottom.trailing.equalTo(imageView).inset(8)
        }
        
        mallLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(imageView).inset(8)
            make.height.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallLabel.snp.bottom)
            make.horizontalEdges.equalTo(mallLabel)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges.equalTo(mallLabel)
            make.bottom.lessThanOrEqualToSuperview()
            make.height.equalTo(20)
        }
    }
    
    func configureView() { }
}
