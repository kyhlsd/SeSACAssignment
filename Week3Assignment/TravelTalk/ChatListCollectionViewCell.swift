//
//  ChatListCollectionViewCell.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/18/25.
//

import UIKit

class ChatListCollectionViewCell: UICollectionViewCell, Identifying {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.clipsToBounds = true
    }
    
    override func draw(_ rect: CGRect) {
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    }

    func configure(with chatRoom: ChatRoom) {
        profileImageView.image = UIImage(named: chatRoom.chatroomImage)
        nameLabel.text = chatRoom.chatroomName
        
        dateLabel.text = DateStringFormatter.getConvertedDateString(from: DateStringFormatter.yyyyMMddHHmmDashFormatter, to: DateStringFormatter.yyMMddDotFormatter, dateString: chatRoom.lastChatDate)
        
        messageLabel.text = chatRoom.lastChatMessage
    }
}
