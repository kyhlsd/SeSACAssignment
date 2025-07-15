//
//  AdTableViewCell.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/12/25.
//

import UIKit

class AdTableViewCell: UITableViewCell, ReuseIdentifying {
    
    @IBOutlet var adContainerView: UIView!
    @IBOutlet var adLabel: UILabel!
    @IBOutlet var adTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        adContainerView.layer.cornerRadius = 12
        adLabel.layer.cornerRadius = 8
        adLabel.clipsToBounds = true
    }

    func configure(with travel: Travel, isOddAd: Bool) {
        adTitleLabel.text = travel.title
        adContainerView.backgroundColor = isOddAd ? .systemPink : .systemGreen
    }
}
