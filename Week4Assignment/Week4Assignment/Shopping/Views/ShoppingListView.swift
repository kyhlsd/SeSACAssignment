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
    
    let collectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 12, right: 12)
        
        let deviceWidth = UIScreen.main.bounds.width
        let width = (deviceWidth - (12 * 2) - 12) / 2
        layout.itemSize = CGSize(width: width, height: width + 80)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cellType: ShoppingListCollectionViewCell.self)
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
        [collectionView, optionStackView, totalCountLabel].forEach {
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
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(optionStackView.snp.bottom).offset(12)
            make.horizontalEdges.bottom.equalTo(safeArea)
        }
    }
    
    func configureView() {
        backgroundColor = .black
    }
}
