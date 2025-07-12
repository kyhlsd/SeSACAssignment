//
//  TravelTableViewCell.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/12/25.
//

import UIKit
import Kingfisher

class TravelTableViewCell: UITableViewCell {
    
    @IBOutlet var travelImageView: UIImageView!
    @IBOutlet var travelTitleLabel: UILabel!
    @IBOutlet var travelDescriptionLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var starStackView: UIStackView!
    @IBOutlet var heartButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        travelImageView.layer.cornerRadius = 12
        travelImageView.kf.indicatorType = .activity
    }

    func configure(with travel: Travel) {
        travelTitleLabel.text = travel.title
        travelDescriptionLabel.text = travel.description
        if let save = travel.save, let gradeCount = travel.gradeCount {
            countLabel.text = "\(getDemicalIntString(from: gradeCount)) · 저장 \(getDemicalIntString(from: save))"
        }
        
        if let travelImage = travel.travelImage {
            let url = URL(string: travelImage)
            travelImageView.kf.setImage(with: url)
        }
        
        if let like = travel.like {
            let heartImage = like ? "heart.fill" : "heart"
            heartButton.setImage(UIImage(systemName: heartImage), for: .normal)
        }
        
        if let grade = travel.grade {
            for (i, star) in starStackView.subviews.enumerated() {
                let starString = i < Int(grade) ? "star.fill" : "star"
                let tintColor = i < Int(grade) ? UIColor.systemYellow : UIColor.systemGray4
                if let starImage = star as? UIImageView {
                    starImage.image = UIImage(systemName: starString)
                    starImage.tintColor = tintColor
                }
            }
        }
    }
}

func getDemicalIntString(from number: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    if let result = formatter.string(for: number) {
        return result
    } else {
        return "잘못된 형식입니다."
    }
}
