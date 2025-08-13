//
//  BadgeLayerButton.swift
//  MVVMBasic
//
//  Created by 김영훈 on 8/11/25.
//

import UIKit
import SnapKit

final class BadgeLayerButton: UIButton {
    let mainImageView = UIImageView()
    let badgeImageView = UIImageView()
    
    private let color: UIColor
    private let borderWidth: CGFloat
    private let badgeSize: CGFloat
    
    init(mainImage: UIImage?, badgeImage: UIImage?, color: UIColor, borderWidth: CGFloat, badgeSize: CGFloat) {
        self.mainImageView.image = mainImage
        self.badgeImageView.image = badgeImage
        self.color = color
        self.borderWidth = borderWidth
        self.badgeSize = badgeSize
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        badgeImageView.snp.makeConstraints { make in
            make.size.equalTo(badgeSize)
            make.center.equalTo(self).offset(sin(45 * Double.pi / 180) * self.frame.height / 2)
        }
        
        mainImageView.layer.cornerRadius = mainImageView.frame.height / 2
    }
    
    private func setupUI() {
        setupMainImageView()
        setupBadgeImageView()
        
        addSubview(mainImageView)
        addSubview(badgeImageView)
        
        mainImageView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    private func setupMainImageView() {
        mainImageView.contentMode = .scaleAspectFit
        mainImageView.layer.borderColor = color.cgColor
        mainImageView.layer.borderWidth = borderWidth
        mainImageView.clipsToBounds = true
    }
    
    private func setupBadgeImageView() {
        badgeImageView.layer.cornerRadius = badgeSize / 2
        badgeImageView.clipsToBounds = true
    }
}
