//
//  SearchShoppingView.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/26/25.
//

import UIKit
import SnapKit

final class SearchShoppingView: UIView {
    let searchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundImage = UIImage()
        searchBar.overrideUserInterfaceStyle = .dark
        searchBar.placeholder = "브랜드, 상품, 프로필, 태그 등"
        return searchBar
    }()
    
    let backgroundImageView = {
        let imageView = UIImageView()
        imageView.image = .shoppingBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let backgroundLabel = {
        let label = UILabel()
        label.text = "쇼핑하구팡"
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViewDesign()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchShoppingView: ViewDesignProtocol {
    func configureHierarchy() {
        [searchBar, backgroundImageView, backgroundLabel].forEach {
            addSubview($0)
        }
    }
    
    func configureLayout() {
        let safeArea = safeAreaLayoutGuide
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeArea)
            make.horizontalEdges.equalTo(safeArea).inset(12)
            make.height.equalTo(44)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeArea).inset(40)
            make.height.equalTo(backgroundImageView.snp.width).multipliedBy(0.6)
            make.centerY.equalTo(safeArea)
        }
        
        backgroundLabel.snp.makeConstraints { make in
            make.centerX.equalTo(safeArea)
            make.top.equalTo(backgroundImageView.snp.bottom).offset(40)
        }
    }
    
    func configureView() {
        backgroundColor = .black
    }
}
