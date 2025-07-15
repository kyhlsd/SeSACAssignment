//
//  TravelTableViewCell.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/12/25.
//

import UIKit
import Kingfisher

class TravelTableViewCell: UITableViewCell, Identifying {
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        heartButton.removeTarget(nil, action: nil, for: .allEvents)
    }

    func configure(with travel: Travel) {
        travelTitleLabel.text = travel.title
        travelDescriptionLabel.text = travel.description
        
        if let save = IntToDemicalStringFormatter.formatter.string(for: travel.save),
           let gradeCount = IntToDemicalStringFormatter.formatter.string(for: travel.gradeCount) {
            countLabel.text = "\(gradeCount) · 저장 \(save)"
        }
        
        if let travelImage = travel.travelImage {
            let url = URL(string: travelImage)
            travelImageView.kf.setImage(with: url)
        }
        
        if let like = travel.like {
            configureHeartButton(like)
        }
        
        if let grade = travel.grade {
            configureStarStackView(grade)
        }
    }
    
    func configureHeartButton(_ like: Bool) {
        let heartImage = like ? "heart.fill" : "heart"
        heartButton.setImage(UIImage(systemName: heartImage), for: .normal)
    }
    
    private func configureStarStackView(_ grade: Float) {
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
