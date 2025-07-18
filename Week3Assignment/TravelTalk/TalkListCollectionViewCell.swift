//
//  TalkListCollectionViewCell.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/18/25.
//

import UIKit

class TalkListCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet var ProfileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
