//
//  UpDownGameCollectionViewCell.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/17/25.
//

import UIKit

class UpDownGameCollectionViewCell: UICollectionViewCell, Identifying {

    @IBOutlet var numberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        numberLabel.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height / 2
    }

    func configure(_ number: Int) {
        numberLabel.text = "\(number)"
    }
}
