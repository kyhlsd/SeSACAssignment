//
//  TestTableViewCell.swift
//  Tamagotchi
//
//  Created by 김영훈 on 8/27/25.
//

import UIKit

class TestTableViewCell: UITableViewCell {

    override func prepareForReuse() {
        super.prepareForReuse()
        print("reuse")
    }

}
