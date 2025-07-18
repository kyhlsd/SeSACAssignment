//
//  CityCollectionViewCell.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/17/25.
//

import UIKit
import Kingfisher

class CityCollectionViewCell: UICollectionViewCell, Identifying {

    @IBOutlet var cityImageView: UIImageView!
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var cityExplainLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cityImageView.kf.indicatorType = .activity
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        cityImageView.layer.cornerRadius = cityImageView.frame.height / 2
    }

    func configure(with city: City, searchText: String) {
        cityNameLabel.setAttributedTextlWithKeyword(text: "\(city.cityName) | \(city.cityEnglishName)", keyword: searchText, pointColor: .systemRed)
        cityExplainLabel.setAttributedTextlWithKeyword(text: city.cityExplain, keyword: searchText, pointColor: .systemRed)
        
        let url = URL(string: city.cityImage)
        cityImageView.kf.setImage(with: url, options: [
            .processor(DownsamplingImageProcessor(size: CGSize(width: 150, height: 150))),
            .scaleFactor(UIScreen.main.scale),
            .cacheOriginalImage
        ])
    }
}
