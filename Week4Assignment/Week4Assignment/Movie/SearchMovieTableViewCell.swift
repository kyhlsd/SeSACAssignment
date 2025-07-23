//
//  SearchMovieTableViewCell.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/23/25.
//

import UIKit
import SnapKit

class SearchMovieTableViewCell: UITableViewCell, Identifying {
    
    private let indexLabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "10"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    private let titleLabel = {
        let label = UILabel()
        label.text = "스케어리 스토리: 어둠의 속"
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    private let dateLabel = {
        let label = UILabel()
        label.text = "8888-88-88"
        label.textColor = .lightGray
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViewDesign()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchMovieTableViewCell: ViewDesignProtocol {
    func configureHierarchy() {
        [indexLabel, titleLabel, dateLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    func configureLayout() {
        indexLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(8)
            make.width.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(indexLabel)
            make.leading.equalTo(indexLabel.snp.trailing).offset(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.verticalEdges.equalTo(indexLabel)
            make.leading.equalTo(titleLabel.snp.trailing).offset(20)
            make.width.equalTo(80)
        }
    }
    
    func configureView() {
        backgroundColor = .clear
    }
}
