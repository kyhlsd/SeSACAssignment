//
//  AdDetailViewController.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/15/25.
//

import UIKit

class AdDetailViewController: UIViewController, Identifying {

    @IBOutlet var adTitleLabel: UILabel!

    weak var delegate: TravelViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let travel = delegate?.selectedTravel {
            configure(with: travel)
        }
    }

    func configure(with travel: Travel) {
        adTitleLabel.text = travel.title
    }
    
    @IBAction func exitBarButtonItemTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
