//
//  NewDateSendMessageTableViewCell.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/22/25.
//

import UIKit

class NewDateSendMessageTableViewCell: SendMessageTableViewCell {

    @IBOutlet var newDateLabel: UILabel!

    override func configureData(with chat: Chat) {
        super.configureData(with: chat)
        newDateLabel.text = DateStringFormatter.getConvertedDateString(from: DateStringFormatter.yyyyMMddHHmmDashFormatter, to: DateStringFormatter.koreanFormatter, dateString: chat.date)
    }
}
