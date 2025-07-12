//
//  MagazineTableViewCell.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/11/25.
//

import UIKit
import Kingfisher

class MagazineTableViewCell: UITableViewCell {
    
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
        magazineDateLabel.text = getConvertedString(from: magazine.date)

        let url = URL(string: magazine.photoImage)
        magazineImageView.kf.setImage(with: url)
    }
}

// "yyMMdd" -> "yy년 MM월 dd일" 변환
func getConvertedString(from dateString: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyMMdd"
    if let date = formatter.date(from: dateString) {
        formatter.dateFormat = "yy년 MM월 dd일"
        return formatter.string(from: date)
    } else {
        return "잘못된 날짜 형식입니다."
    }
}

