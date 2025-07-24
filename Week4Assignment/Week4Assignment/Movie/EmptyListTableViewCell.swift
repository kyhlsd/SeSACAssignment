//
//  EmptyListTableViewCell.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/24/25.
//

import UIKit
import SnapKit

final class EmptyListTableViewCell: UITableViewCell, Identifying {
    private let label = {
        let label = UILabel()
        label.text = "검색 결과가 없습니다."
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
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

extension EmptyListTableViewCell: ViewDesignProtocol {
    func configureHierarchy() {
        contentView.addSubview(label)
    }
    
    func configureLayout() {
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureView() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}
