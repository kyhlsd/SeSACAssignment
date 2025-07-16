//
//  CityTableViewCell.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/15/25.
//

import UIKit
import Kingfisher

class CityTableViewCell: UITableViewCell, Identifying {
    
    @IBOutlet var cityShadowView: UIView!
    @IBOutlet var cityContainerView: UIView!
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var cityImageView: UIImageView!
    @IBOutlet var cityExplainLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cityImageView.kf.indicatorType = .activity
        
        cityContainerView.setCornerRadius(corners: [.layerMinXMinYCorner, .layerMaxXMaxYCorner], cornerRadius: 12)
        cityShadowView.layer.setRightBottomShadow()
    }
    
    func configure(with city: City) {
        cityNameLabel.text = "\(city.cityName) | \(city.cityEnglishName)"
        
        let url = URL(string: city.cityImage)
        cityImageView.kf.setImage(with: url, options: [
            .processor(DownsamplingImageProcessor(size: CGSize(width: 300, height: 100))),
            .scaleFactor(UIScreen.main.scale),
            .cacheOriginalImage
        ])
        
        cityExplainLabel.text = "  " + city.cityExplain
    }
}
