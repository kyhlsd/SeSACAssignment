//
//  MagazineTableViewCell.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/11/25.
//

import UIKit
import Kingfisher

class MagazineTableViewCell: UITableViewCell, Identifying {
    
    @IBOutlet var magazineImageView: UIImageView!
    @IBOutlet var magazineTitleLabel: UILabel!
    @IBOutlet var magazineSubtitleLabel: UILabel!
    @IBOutlet var magazineDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        magazineImageView.layer.cornerRadius = 12
        magazineImageView.kf.indicatorType = .activity
    }

    func configure(with magazine: Magazine) {
        magazineTitleLabel.text = magazine.title
        magazineSubtitleLabel.text = magazine.subtitle

        let date = DateStringFormatter.yyMMddFormatter.date(from: magazine.date)
        magazineDateLabel.text = DateStringFormatter.koreanFormatter.string(for: date)
        
        let url = URL(string: magazine.photoImage)
        magazineImageView.kf.setImage(with: url)
    }
}

