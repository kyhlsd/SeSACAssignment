//
//  SelectTamagotchiCollectionViewCell.swift
//  Tamagotchi
//
//  Created by 김영훈 on 8/23/25.
//

import UIKit
import SnapKit

final class SelectTamagotchiCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: SelectTamagotchiCollectionViewCell.self)
    
    private let imageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let insetLabel = {
        let label = InsetLabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemIndigo
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.blue.cgColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        imageView.layer.cornerRadius = imageView.frame.height / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        insetLabel.text = nil
    }
    
    func setData(type: TamagotchiType) {
        imageView.image = UIImage(named: type.defaultImage)
        insetLabel.text = type.rawValue
    }
    
    private func setupUI() {
        [imageView, insetLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setupLayout() {
        imageView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
        insetLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.centerX.bottom.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
    }
}
