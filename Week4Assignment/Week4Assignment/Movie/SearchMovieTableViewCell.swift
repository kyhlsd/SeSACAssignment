//
//  SearchMovieTableViewCell.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/23/25.
//

import UIKit
import SnapKit

final class SearchMovieTableViewCell: UITableViewCell, Identifying {
    
    private let indexLabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    private let titleLabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    private let dateLabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private let dateLabelAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.monospacedDigitSystemFont(ofSize: 12, weight: .semibold),
        .kern: 0,
        .foregroundColor: UIColor.systemGray
    ]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViewDesign()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureData(with movie: Movie, index: Int, searchText: String) {
        indexLabel.text = "\(index)"
        titleLabel.setAttributedTextlWithKeyword(text: movie.title, keyword: searchText, pointColor: .systemRed)

        let dateString = DateFormatters.getConvertedDateString(from: DateFormatters.yyyyMMddFormatter, to: DateFormatters.yyyyMMddDashFormatter, dateString: movie.releaseDate) ?? ""
        dateLabel.setAttributedTextlWithKeyword(text: dateString, keyword: searchText, pointColor: .systemRed, attributes: dateLabelAttributes)
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
        selectionStyle = .none
    }
}
