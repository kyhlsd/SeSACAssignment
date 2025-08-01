//
//  ShoppingListView.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/26/25.
//

import UIKit
import SnapKit

final class ShoppingListView: UIView {
    let totalCountLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemGreen
        return label
    }()
    
    let optionStackView = {
        let list = SortOption.allCases.map { $0.rawValue }
        let optionStackView = OptionStackView(list: list)
        return optionStackView
    }()
    
    let searchedCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 12, right: 12)
        
        let deviceWidth = UIScreen.main.bounds.width
        let width = (deviceWidth - (12 * 2) - 12) / 2
        layout.itemSize = CGSize(width: width, height: width + 80)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cellType: SearchedCollectionViewCell.self)
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    let emptyLabel = {
        let label = UILabel()
        label.text = "검색 결과가 없습니다."
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    let recommendedCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 12, right: 12)
        
        let cellWidth = 80.0
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth + 38)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cellType: RecommendedCollectionViewCell.self)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewDesign()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ShoppingListView: ViewDesignProtocol {
    func configureHierarchy() {
        [searchedCollectionView, optionStackView, totalCountLabel, emptyLabel, recommendedCollectionView].forEach {
            addSubview($0)
        }
    }
    
    func configureLayout() {
        let safeArea = safeAreaLayoutGuide
        
        totalCountLabel.snp.makeConstraints { make in
            make.top.equalTo(safeArea)
            make.horizontalEdges.equalTo(safeArea).inset(12)
            make.height.equalTo(18)
        }
        
        optionStackView.snp.makeConstraints { make in
            make.top.equalTo(totalCountLabel.snp.bottom).offset(8)
            make.leading.equalTo(totalCountLabel)
            make.trailing.lessThanOrEqualTo(totalCountLabel)
            make.height.equalTo(36)
        }
        
        searchedCollectionView.snp.makeConstraints { make in
            make.top.equalTo(optionStackView.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(safeArea)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.edges.equalTo(searchedCollectionView)
        }
        
        recommendedCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchedCollectionView.snp.bottom).offset(12)
            make.horizontalEdges.bottom.equalTo(safeArea)
            make.height.equalTo(140)
        }
    }
    
    func configureView() {
        backgroundColor = .black
    }
}
