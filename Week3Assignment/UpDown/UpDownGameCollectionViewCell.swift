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
        print(#function, frame.height)
        print(#function, numberLabel.frame.height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print(#function, frame.height)
        print(#function, numberLabel.frame.height)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        numberLabel.layer.cornerRadius = numberLabel.frame.height / 2
        print(#function, frame.height)
        print(#function, numberLabel.frame.height)
    }
    
    func configure(_ number: Int) {
        numberLabel.text = "\(number)"
    }
}
