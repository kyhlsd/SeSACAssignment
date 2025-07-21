//
//  SendMessageTableViewCell.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/20/25.
//

import UIKit

class SendMessageTableViewCell: UITableViewCell, Identifying {

    @IBOutlet var messageContainerView: UIView!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
    }
    
    private func configureUI() {
        messageContainerView.layer.cornerRadius = 12
        messageContainerView.layer.borderColor = UIColor.gray.cgColor
        messageContainerView.layer.borderWidth = 0.5
    }
    
    func configureData(with chat: Chat) {
        messageLabel.text = chat.message
        
        if let date = DateStringFormatter.yyyyMMddHHmmDashFormatter.date(from: chat.date) {
            timeLabel.text = DateStringFormatter.koreanTimeFormatter.string(from: date)
        } else {
            timeLabel.text = ""
        }
    }
}
