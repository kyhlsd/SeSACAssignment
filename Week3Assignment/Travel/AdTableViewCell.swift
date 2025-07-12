//
//  AdTableViewCell.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/12/25.
//

import UIKit

class AdTableViewCell: UITableViewCell {

    
    @IBOutlet var adContainerView: UIView!
    @IBOutlet var adLabel: UILabel!
    
    @IBOutlet var adTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        adContainerView.layer.cornerRadius = 12
        adLabel.layer.cornerRadius = 4
    }

    func configure(with travel: Travel) {
        adTitleLabel.text = travel.title
    }
}
