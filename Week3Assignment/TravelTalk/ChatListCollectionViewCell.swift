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
        
        guard let lastChat = chatRoom.chatList.last else {
            dateLabel.text = ""
            messageLabel.text = ""
            return
        }
        
        let dashFormatter = DateStringFormatter.yyyyMMddHHmmDashFormatter()
        if let date = dashFormatter.date(from: lastChat.date) {
            let dotFormatter = DateStringFormatter.yyMMddDotFormatter()
            dateLabel.text = dotFormatter.string(from: date)
        }
        messageLabel.text = lastChat.message
    }
}
