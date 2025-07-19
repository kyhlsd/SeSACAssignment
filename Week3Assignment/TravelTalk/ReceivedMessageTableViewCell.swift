//
//  ReceivedMessageTableViewCell.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/18/25.
//

import UIKit

class ReceivedMessageTableViewCell: UITableViewCell, Identifying {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var messageContainerView: UIView!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
    }
    
    private func configureUI() {
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true
        
        messageContainerView.layer.cornerRadius = 12
        messageContainerView.layer.borderColor = UIColor.black.cgColor
        messageContainerView.layer.borderWidth = 0.5
    }
    
    func configureData(with chat: Chat) {
        nameLabel.text = chat.user.name
        profileImageView.image = UIImage(named: chat.user.image)
        messageLabel.text = chat.message
        
        let dashFormatter = DateStringFormatter.yyyyMMddHHmmDashFormatter()
        if let date = dashFormatter.date(from: chat.date) {
            let timeFormatter = DateStringFormatter.koreanTimeFormatter()
            timeLabel.text = timeFormatter.string(from: date)
        } else {
            timeLabel.text = ""
        }
    }
}
